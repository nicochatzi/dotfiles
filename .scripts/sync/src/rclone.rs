use crate::*;
use clap::Args;
use std::path::PathBuf;
use thiserror::Error;

#[derive(Debug, Args)]
pub struct RcloneOpts {
    /// Name of the configured rclone remote
    #[arg(long, default_value = "proton")]
    remote: String,

    /// Destination directory for cloud sync
    #[arg(long, default_value = "~/cloud")]
    local: PathBuf,

    /// Backup for archiving cloud data, used if sync is enabled
    #[arg(long, default_value = "~/archive")]
    backup: PathBuf,

    /// Check the local copy is in sync with cloud
    /// Otherwise just sync the local with cloud
    #[arg(long, default_value_t = true)]
    check: bool,

    /// Log output directory, otherwise print to console
    #[arg(long, default_value = None)]
    log_dir: Option<PathBuf>,
}

#[derive(Debug, Error)]
enum RcloneError {
    #[error("CLI error: {0}")]
    Cli(#[from] shell::Error),

    #[error("IO error: {0}")]
    IoError(#[from] std::io::Error),
}

type RcloneResult<T> = Result<T, RcloneError>;

fn sync(opts: RcloneOpts) -> RcloneResult<()> {
    let timestamp = chrono::Utc::now().timestamp();
    let backup = opts.backup.join(&opts.remote).join(timestamp.to_string());

    let cmd = format!(
        "rclone sync {remote}: {local} --backup-dir {backup} --progress",
        remote = opts.remote,
        local = opts.local.display(),
        backup = backup.display(),
    );

    let out = shell::run(cmd)?;
    log::trace!("{out}");

    Ok(())
}

fn check(opts: RcloneOpts) -> RcloneResult<()> {
    let cmd = format!(
        "rclone check {remote}: {local} --one-way",
        remote = opts.remote,
        local = opts.local.display(),
    );

    let out = shell::run(cmd)?;
    log::trace!("{out}");

    Ok(())
}

fn run_with_opts(opts: RcloneOpts) -> RcloneResult<()> {
    if opts.check {
        check(opts)
    } else {
        sync(opts)
    }
}

pub fn run(opts: RcloneOpts) {
    let logfile = opts
        .log_dir
        .as_ref()
        .map(|dir| dir.join(format!("sync_{}.log", opts.remote)));
    logging::setup(&logfile).unwrap();

    if let Err(e) = run_with_opts(opts) {
        log::error!("{e}");
    }
}
