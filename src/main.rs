mod formater;

use crate::formater::format;
use anyhow::{Context, Result, bail};
use arboard::Clipboard;
use clap::{ArgGroup, Parser, ValueEnum};
use log::LevelFilter;
use std::fs::File;
use std::io::{BufWriter, Cursor, Write, stdout};
use std::path::PathBuf;

/// A common text processing tool that supports clipboard and file input.
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
#[clap(group(ArgGroup::new("input_source").required(true)))]
struct Args {
    /// Using clipboard as input
    #[arg(short, group = "input_source")]
    clip: bool,

    /// Using a file as input
    #[arg(short, long, group = "input_source")]
    input: Option<String>,

    /// Output format
    #[arg(short, long, value_enum)]
    format: FormatType,

    /// Output file path
    #[arg(short, long)]
    output: Option<String>,

    /// Copy the formatted content back to clipboard
    #[arg(short, long)]
    back: bool,
}

#[derive(ValueEnum, Clone, Debug, PartialEq)]
#[clap(rename_all = "kebab-case")]
pub enum FormatType {
    Json,
    Yaml,
    Xml,
}

struct FormatContext {
    file_list: Vec<PathBuf>,
    clipboard_content: String,
}

fn main() -> Result<()> {
    // 设置 log
    env_logger::builder()
        .filter_level(LevelFilter::Debug)
        .init();

    let args = Args::parse();

    if args.clip && args.input.is_some() {
        bail!("Cannot use both clipboard and file input at the same time");
    }

    let mut context = FormatContext {
        file_list: Vec::new(),
        clipboard_content: String::new(),
    };

    let mut clipboard = Clipboard::new().context("Unable to access the clipboard")?;

    if args.clip {
        process_clipboard(&mut context, &mut clipboard).context("Failed to process clipboard")?;
    }

    if let Some(file_path) = args.input {
        context.file_list.push(PathBuf::from(file_path));
    }

    if context.file_list.is_empty() && context.clipboard_content.is_empty() {
        bail!("No input provided. Please use --clip or --input to specify input source.");
    }

    // 只允许接受一个输入源
    if context.file_list.len() > 1 {
        bail!("Multiple input files provided. Please use only one file or clipboard input.");
    }

    let mut copy_buf = Vec::new();
    // 处理格式化
    if context.file_list.len() == 1 {
        let file_path = &context.file_list[0];
        log::info!("Processing file: {:?}", file_path);
        let mut file = File::open(file_path)?;
        format(&mut file, &mut copy_buf, args.format.clone())
            .context(format!("Failed to format file: {}", file_path.display()))?;
    }

    if !context.clipboard_content.is_empty() {
        log::info!("Processing clipboard content");
        let mut cursor = Cursor::new(context.clipboard_content);
        format(&mut cursor, &mut copy_buf, args.format)
            .context("Failed to format clipboard content")?;
    }

    if args.back {
        log::info!("Copying formatted content back to clipboard");
        clipboard
            .set_text(
                String::from_utf8(copy_buf.clone())
                    .context("Failed to convert formatted content to string")?,
            )
            .context("Failed to copy formatted content to clipboard")?;
    }

    // 输出结果
    if let Some(output_path) = args.output {
        log::info!("Writing output to file: {}", output_path);
        let output_file = File::create(output_path).context("Failed to create output file")?;
        let mut writer = BufWriter::new(output_file);
        writer
            .write_all(&copy_buf)
            .context("Failed to write formatted content to output file")?;
    } else {
        log::info!("Outputting formatted content to stdout");
        stdout()
            .write_all(&copy_buf)
            .context("Failed to write formatted content to stdout")?;
    }

    Ok(())
}

fn process_clipboard(ctx: &mut FormatContext, clip: &mut Clipboard) -> Result<()> {
    if let Ok(files) = clip.get().file_list() {
        ctx.file_list.extend(files);
        return Ok(());
    }

    if let Ok(text) = clip.get_text() {
        ctx.clipboard_content = text;
    } else {
        bail!("Failed to read clipboard text")
    }

    Ok(())
}
