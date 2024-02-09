pub mod feeds;
pub mod theme;

use clap::{Parser, Subcommand};

#[derive(Debug, Parser)]
#[clap(author, version, about, long_about = None)]
pub struct Cli {
    #[clap(subcommand)]
    command: Cmd,
}

#[derive(Debug, Subcommand)]
pub enum Cmd {
    Theme(theme::ThemeCmd),
    Feeds(feeds::FeedsCmd),
}

pub fn main() {
    match Cli::parse().command {
        Cmd::Theme(cmd) => theme::run(cmd).unwrap(),
        Cmd::Feeds(cmd) => feeds::run(cmd).unwrap(),
    }
}
