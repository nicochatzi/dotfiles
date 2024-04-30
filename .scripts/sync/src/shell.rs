use thiserror::Error;

#[derive(Debug)]
pub struct Failed {
    cmd: String,
    msg: String,
}

impl std::fmt::Display for Failed {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(
            f,
            "Failed to execute command: {}\nwith: {}",
            self.cmd, self.msg
        )
    }
}

#[derive(Debug, Error)]
pub enum Error {
    #[error("No command provided: {0}")]
    NoCommandProvided(String),

    #[error("IO error: {0}")]
    IoError(#[from] std::io::Error),

    #[error("Failed to execute: {0}")]
    Failed(Failed),
}

pub fn run(cmd: impl AsRef<str>) -> Result<String, Error> {
    let input = cmd.as_ref();
    let mut parts = input.split_whitespace();
    let cmd = parts
        .next()
        .ok_or_else(|| Error::NoCommandProvided(input.to_owned()))?;
    let args: Vec<&str> = parts.collect();

    let output = std::process::Command::new(cmd)
        .args(args)
        .output()
        .map_err(|e| Error::IoError(e))?;

    if !output.status.success() {
        return Err(Error::Failed(Failed {
            cmd: input.to_owned(),
            msg: String::from_utf8_lossy(&output.stderr).to_string(),
        }));
    }

    Ok(String::from_utf8_lossy(&output.stdout).to_string())
}
