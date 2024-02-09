use std::{
    os::unix::fs,
    path::{Path, PathBuf},
    time::SystemTime,
};

struct ThemeSelector {
    link: &'static str,
    light: &'static str,
    dark: &'static str,
}

const ALACRITTY_CONF: &str = "~/.config/alacritty/alacritty.toml";
const THEME_FILES: &[ThemeSelector] = &[
    ThemeSelector {
        link: "~/.config/alacritty/theme.toml",
        light: "~/.config/alacritty/light.toml",
        dark: "~/.config/alacritty/dark.toml",
    },
    ThemeSelector {
        link: "~/.config/gtk-3.0/settings.ini",
        light: "~/.config/gtk-3.0/light.ini",
        dark: "~/.config/gtk-3.0/dark.ini",
    },
    ThemeSelector {
        link: "~/.config/nvim/lua/config/theme/init.lua",
        light: "~/.config/nvim/lua/config/theme/light.lua",
        dark: "~/.config/nvim/lua/config/theme/dark.lua",
    },
];

#[derive(Debug, clap::Args)]
pub struct ThemeCmd {
    #[clap(subcommand)]
    command: Cmd,
}

#[derive(Debug, clap::Subcommand)]
enum Cmd {
    Toggle,
    Light,
    Dark,
}

pub fn run(cmd: ThemeCmd) -> anyhow::Result<()> {
    match cmd.command {
        Cmd::Toggle => set_theme(!is_light_mode()?),
        Cmd::Light => set_theme(true),
        Cmd::Dark => set_theme(false),
    }
}

pub fn is_light_mode() -> anyhow::Result<bool> {
    let path = expand_home(THEME_FILES[0].link)?;
    let does_link_to_link = std::fs::read_link(path)?
        .file_name()
        .unwrap()
        .to_ascii_lowercase()
        .to_str()
        .unwrap()
        .contains("light");
    Ok(does_link_to_link)
}

pub fn set_theme(to_light: bool) -> anyhow::Result<()> {
    for f in THEME_FILES {
        let src = expand_home(if to_light { f.light } else { f.dark })?;
        let dest = expand_home(f.link)?;
        create_symlink(src, dest)?;
    }
    touch_alacritty_config()?;
    Ok(())
}

pub fn create_symlink(src: impl AsRef<Path>, dest: impl AsRef<Path>) -> anyhow::Result<()> {
    let src = src.as_ref();
    let dest = dest.as_ref();
    if !src.exists() {
        anyhow::bail!("file does not exist: {src:?}")
    }
    println!("linking {src:?} to {dest:?}");
    std::fs::remove_file(dest)?;
    fs::symlink(src, dest)?;
    Ok(())
}

pub fn expand_home(path: impl AsRef<Path>) -> anyhow::Result<PathBuf> {
    let path = path.as_ref();
    if !path.starts_with("~") {
        return Ok(path.to_path_buf());
    }
    let Some(mut home) = dirs::home_dir() else {
        anyhow::bail!("could not resolve home directory");
    };
    if path == Path::new("~") {
        return Ok(home);
    }
    if home == Path::new("/") {
        Ok(path.strip_prefix("~").unwrap().to_path_buf())
    } else {
        home.push(path.strip_prefix("~/").unwrap());
        Ok(home)
    }
}

pub fn touch_alacritty_config() -> anyhow::Result<()> {
    let current_time = SystemTime::now();
    let conf = expand_home(ALACRITTY_CONF)?;
    let _file = std::fs::OpenOptions::new().write(true).open(&conf)?;
    filetime::set_file_mtime(conf, filetime::FileTime::from_system_time(current_time))?;
    Ok(())
}
