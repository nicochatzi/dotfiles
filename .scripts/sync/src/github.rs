use crate::*;
use clap::Args;
use serde::Deserialize;
use std::path::{Path, PathBuf};
use thiserror::Error;

#[derive(Debug, Args)]
pub struct GitHubOpts {
    /// Destination directory for repositories
    #[arg(long, default_value = "~/code")]
    dest: PathBuf,

    /// Run the command without actually doing anything
    #[arg(long, default_value_t = false)]
    dry_run: bool,

    /// Log output directory, otherwise print to console
    #[arg(long, default_value = None)]
    log_dir: Option<PathBuf>,
}

#[derive(Debug, Error)]
enum GitHubError {
    #[error("CLI error: {0}")]
    Cli(#[from] shell::Error),

    #[error("Deserialization error: {0}")]
    Deserialize(#[from] serde_json::Error),

    #[error("IO error: {0}")]
    IoError(#[from] std::io::Error),
}

type GitHubResult<T> = Result<T, GitHubError>;

struct Repo {
    user: String,
    name: String,
    path: PathBuf,
}

impl Repo {
    fn new(user: String, name: String, dir: impl AsRef<Path>) -> GitHubResult<Self> {
        let subfolder = if Repo::is_fork(&user, &name)? {
            "oss"
        } else {
            "me"
        };
        let path = dir.as_ref().join(subfolder).join(&name);
        Ok(Self { user, name, path })
    }

    fn all(dir: &impl AsRef<Path>) -> GitHubResult<Vec<Self>> {
        #[derive(Debug, Deserialize)]
        struct GhRepoView {
            #[serde(skip_serializing_if = "Option::is_none")]
            login: Option<String>,
            #[serde(skip_serializing_if = "Option::is_none")]
            name: Option<String>,
        }

        let response = shell::run("gh api user")?;
        let user: GhRepoView =
            serde_json::from_str(&response).map_err(|e| GitHubError::Deserialize(e))?;

        let response = shell::run("gh repo list --json name")?;
        let repo_list: Vec<GhRepoView> =
            serde_json::from_str(&response).map_err(|e| GitHubError::Deserialize(e))?;

        let mut repos = Vec::with_capacity(repo_list.len());
        for repo in repo_list {
            repos.push(Self::new(
                user.login.as_ref().unwrap().clone(),
                repo.name.unwrap(),
                &dir,
            )?);
        }

        Ok(repos)
    }

    fn is_on_disk(&self) -> bool {
        self.path.exists()
    }

    fn is_fork(user: &str, name: &str) -> GitHubResult<bool> {
        let cmd = format!("gh repo view {user}/{name} --json isFork");

        Ok(shell::run(cmd)?.contains("true"))
    }

    fn clone(&self) -> GitHubResult<()> {
        log::trace!("cloning repo: {}, into: {}", self.name, self.path.display());

        std::fs::create_dir_all(&self.path).map_err(|e| GitHubError::IoError(e))?;

        let cmd = format!(
            "git clone git@github.com:{user}/{repo}.git --recurse {dest}",
            user = self.user,
            repo = self.name,
            dest = self.path.display()
        );

        let _ = shell::run(cmd)?;
        Ok(())
    }

    fn fetch(&self) -> GitHubResult<()> {
        log::trace!("fetching repo: {}, at: {}", self.name, self.path.display(),);

        let cmd = "git fetch --all --tags";

        let _ = shell::run(cmd)?;
        Ok(())
    }
}

fn fetch(repo: Repo, opts: &GitHubOpts) -> GitHubResult<()> {
    if opts.dry_run {
        log::info!("found existing repo: {}", repo.name);
        return Ok(());
    }
    repo.fetch()
}

fn clone(repo: Repo, opts: &GitHubOpts) -> GitHubResult<()> {
    if opts.dry_run {
        log::info!("found new repo: {}", repo.name);
        return Ok(());
    }
    repo.clone()
}

fn run_with_opts(opts: GitHubOpts) -> GitHubResult<()> {
    for repo in Repo::all(&opts.dest)? {
        if repo.is_on_disk() {
            fetch(repo, &opts)?;
        } else {
            clone(repo, &opts)?;
        }
    }
    Ok(())
}

pub fn run(opts: GitHubOpts) {
    let logfile = opts.log_dir.as_ref().map(|dir| dir.join("sync_github.log"));
    logging::setup(&logfile).unwrap();

    if let Err(e) = run_with_opts(opts) {
        log::error!("{e}");
    }
}
