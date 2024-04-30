mod github;
mod logging;
mod rclone;
mod shell;

use clap::Parser;

#[derive(Debug, Parser)]
#[command(version, about, long_about = None)]
enum Commands {
    Github(github::GitHubOpts),
    Rclone(rclone::RcloneOpts),
}

fn main() {
    match Commands::parse() {
        Commands::Github(opts) => github::run(opts),
        Commands::Rclone(opts) => rclone::run(opts),
    }
}
