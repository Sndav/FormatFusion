mod commands;

use {
    crate::commands::{
        format::{command_format, FormatCommand},
        ip::{command_ip, IpCommand},
    },
    anyhow::Result,
    clap::{Parser, Subcommand},
    log::LevelFilter,
};

/// Skit - A powerful command-line developer toolkit
#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Format text data (JSON, YAML, XML)
    Format(FormatCommand),
    /// Get public IP address information
    Ip(IpCommand),
}

fn main() -> Result<()> {
    // 设置 log
    env_logger::builder().filter_level(LevelFilter::Info).init();

    let args = Cli::parse();

    match args.command {
        Commands::Format(format_args) => {
            command_format(format_args)?;
        }
        Commands::Ip(ip_args) => {
            command_ip(ip_args)?;
        }
    }

    Ok(())
}
