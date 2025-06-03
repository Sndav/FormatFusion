use {
    crate::commands::format::formater::format,
    anyhow::{bail, Context},
    arboard::Clipboard,
    clap::{ArgGroup, Args, ValueEnum},
    std::{
        fs::File,
        io::{stdout, Write},
        path::PathBuf,
    },
};

pub mod formater;

#[derive(ValueEnum, Clone, Debug, PartialEq, Copy)]
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
#[derive(Args)]
#[clap(group(ArgGroup::new("input_source").required(true)))]
pub struct FormatCommand {
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

pub fn command_format(args: FormatCommand) -> anyhow::Result<()> {
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
    if context.file_list.len() > 1
        || (!context.clipboard_content.is_empty() && !context.file_list.is_empty())
    {
        bail!("Only one input source is allowed: either a file or the clipboard.");
    }

    // 处理格式化
    for file in &context.file_list {
        log::info!("Formatting file: {}", file.to_string_lossy());
        let mut file = File::open(file).context(format!("Failed to open file: {:?}", file))?;
        let mut output = Vec::new();
        format(&mut file, &mut output, args.format)
            .context(format!("Failed to format file: {:?}", file))?;

        if let Some(output_path) = &args.output {
            log::info!("Writing formatted content to: {}", output_path);
            let mut output_file = File::create(output_path)
                .context(format!("Failed to create output file: {:?}", output_path))?;
            output_file
                .write_all(&output)
                .context("Failed to write formatted content")?;
        } else {
            log::info!("Formatted content:");
            stdout()
                .write_all(&output)
                .context("Failed to write formatted content to stdout")?;
        }
    }

    // 如果需要，将内容复制回剪贴板
    if args.back {
        if !context.clipboard_content.is_empty() {
            clipboard
                .set_text(context.clipboard_content.clone())
                .context("Failed to copy formatted content back to clipboard")?;
        }
    }

    Ok(())
}

fn process_clipboard(ctx: &mut FormatContext, clip: &mut Clipboard) -> anyhow::Result<()> {
    if let Ok(files) = clip.get().file_list() {
        log::info!("Clipboard contains {} files", files.len());
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
