use crate::FormatType;
use anyhow::Result;
use std::io::{Cursor, Read, Write};

pub fn format<R: Read, W: Write>(
    reader: &mut R,
    writer: &mut W,
    format_type: FormatType,
) -> Result<()> {
    match format_type {
        FormatType::Json => format_json(reader, writer),
        FormatType::Yaml => format_yaml(reader, writer),
        FormatType::Xml => format_xml(reader, writer),
    }
}

/// 格式化 JSON 数据，从 Read 读取，写入 Write
pub fn format_json<R: Read, W: Write>(reader: &mut R, writer: &mut W) -> Result<()> {
    let mut buffer = String::new();
    reader.read_to_string(&mut buffer)?; // 从 reader 读取所有内容到字符串

    let parsed_json: serde_json::Value = serde_json::from_str(&buffer)?; // 解析 JSON
    serde_json::to_writer_pretty(writer, &parsed_json)?; // 漂亮打印到 writer

    Ok(())
}

/// 格式化 YAML 数据，从 Read 读取，写入 Write
pub fn format_yaml<R: Read, W: Write>(reader: &mut R, writer: &mut W) -> Result<()> {
    let mut buffer = String::new();
    reader.read_to_string(&mut buffer)?; // 从 reader 读取所有内容到字符串

    let parsed_yaml: serde_yaml::Value = serde_yaml::from_str(&buffer)?; // 解析 YAML
    serde_yaml::to_writer(writer, &parsed_yaml)?; // 写入到 writer

    Ok(())
}

/// 格式化 XML 数据，从 Read 读取，写入 Write
pub fn format_xml<R: Read, W: Write>(reader: &mut R, writer: &mut W) -> Result<()> {
    let mut buffer = String::new();
    reader.read_to_string(&mut buffer)?; // 从 reader 读取所有内容到字符串

    // xmltree::Element::parse 接受 impl Read，所以可以直接传入 reader
    let parsed_xml = xmltree::Element::parse(Cursor::new(buffer.as_bytes()))?; // 使用 Cursor 包装字符串字节

    // xmltree::Element::write 也接受 impl Write
    parsed_xml.write(writer)?;

    Ok(())
}
