use std::{path::PathBuf, time::SystemTime};

pub fn setup(file: &Option<PathBuf>) -> Result<(), fern::InitError> {
    let cb = |out: fern::FormatCallback, msg: &std::fmt::Arguments, record: &log::Record| {
        out.finish(format_args!(
            "[{} {} {}] {}",
            humantime::format_rfc3339_seconds(SystemTime::now()),
            record.level(),
            record.target(),
            msg
        ))
    };

    match file {
        Some(file) => {
            std::fs::create_dir_all(file.parent().unwrap())?;
            fern::Dispatch::new()
                .format(cb)
                .level(log::LevelFilter::Error)
                .chain(fern::log_file(file)?)
                .apply()?;
        }
        None => fern::Dispatch::new()
            .format(cb)
            .level(log::LevelFilter::Trace)
            .chain(std::io::stdout())
            .apply()?,
    }

    Ok(())
}
