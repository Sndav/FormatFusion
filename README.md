# 📝 FormatFusion

[![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](https://www.rust-lang.org/)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg?style=for-the-badge)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.1.0-green.svg?style=for-the-badge)](Cargo.toml)

> 🚀 一个高性能的多格式文本处理工具，支持 JSON、YAML 和 XML 的美化与格式化

FormatFusion 是一个用 Rust 编写的命令行工具，专为开发者和数据处理专家设计。它可以快速美化和格式化各种常见的数据格式，支持剪贴板操作和文件处理，让您的数据处理工作更加高效。

## ✨ 特性

- 🎯 **多格式支持**: JSON、YAML、XML 格式的智能识别和美化
- 📋 **剪贴板集成**: 直接从剪贴板读取和写入内容
- 📁 **文件处理**: 支持文件输入输出操作
- ⚡ **高性能**: 基于 Rust 构建，处理速度极快
- 🛡️ **错误处理**: 完善的错误处理和日志记录
- 🔧 **灵活配置**: 支持多种输入输出方式

## 🚀 快速开始

### 安装

确保您已安装 Rust 工具链，然后克隆并构建项目：

```bash
git clone https://github.com/Sndav/FormatFusion
cd FormatFusion
cargo build --release
```

### 基本用法

#### 从剪贴板格式化 JSON
```bash
# 从剪贴板读取内容，格式化为 JSON，并输出到控制台
./target/release/beautify --clip --format json

# 格式化后直接复制回剪贴板
./target/release/beautify --clip --format json --back
```

#### 格式化文件
```bash
# 格式化文件并输出到控制台
./target/release/beautify --input data.json --format json

# 格式化文件并保存到新文件
./target/release/beautify --input data.json --format json --output formatted.json
```

#### YAML 和 XML 处理
```bash
# 格式化 YAML 文件
./target/release/beautify --input config.yml --format yaml --output config_formatted.yml

# 格式化 XML 文件
./target/release/beautify --input document.xml --format xml --output document_formatted.xml
```

## 📖 命令行参数

| 参数 | 短参数 | 描述 | 示例 |
|------|--------|------|------|
| `--clip` | `-c` | 使用剪贴板作为输入源 | `-c` |
| `--input` | `-i` | 指定输入文件路径 | `-i data.json` |
| `--format` | `-f` | 指定输出格式 (json/yaml/xml) | `-f json` |
| `--output` | `-o` | 指定输出文件路径 | `-o result.json` |
| `--back` | `-b` | 将格式化结果复制回剪贴板 | `-b` |

## 🎯 使用场景

### 开发调试
```bash
# 快速美化 API 响应的 JSON 数据
curl -s https://api.example.com/data | pbcopy
./target/release/beautify -c -f json -b
```

### 配置文件整理
```bash
# 格式化项目配置文件
./target/release/beautify -i .github/workflows/ci.yml -f yaml -o .github/workflows/ci_formatted.yml
```

### 数据转换
```bash
# 处理 XML 配置文件
./target/release/beautify -i config.xml -f xml -o config_formatted.xml
```

## 🏗️ 项目结构

```
FormatFusion/
├── src/
│   ├── main.rs          # 主程序入口和命令行处理
│   └── formater.rs      # 格式化核心逻辑
├── Cargo.toml           # 项目依赖配置
├── Cargo.lock           # 依赖锁定文件
├── README.md            # 项目说明文档
└── LICENSE              # 项目许可证
```

## 🔧 开发

### 构建项目
```bash
cargo build
```

### 运行测试
```bash
cargo test
```

### 调试模式运行
```bash
RUST_LOG=debug cargo run -- --help
```

### 发布构建
```bash
cargo build --release
```

## 📝 示例

### JSON 美化示例

**输入**:
```json
{"name":"John","age":30,"city":"New York","hobbies":["reading","gaming"]}
```

**输出**:
```json
{
  "name": "John",
  "age": 30,
  "city": "New York",
  "hobbies": [
    "reading",
    "gaming"
  ]
}
```

### YAML 格式化示例

**输入**:
```yaml
name: John
age: 30
city: New York
hobbies: [reading, gaming]
```

**输出**:
```yaml
name: John
age: 30
city: "New York"
hobbies:
- reading
- gaming
```

## 🤝 贡献指南

我们欢迎任何形式的贡献！

1. Fork 此仓库
2. 创建您的功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 📄 许可证

本项目基于 GPL 许可证发布。详情请查看 [LICENSE](LICENSE) 文件。

## 🔮 未来计划

- [ ] 支持更多数据格式 (TOML, CSV, etc.)
- [ ] 添加配置文件支持
- [ ] 实现格式自动检测
- [ ] 添加批量文件处理
- [ ] 提供 GUI 界面
- [ ] 支持自定义格式化规则

## 📞 联系我们

如果您有任何问题或建议，请通过以下方式联系我们：

- 📧 Email: i@sndav.org
- 🐛 Issues: [GitHub Issues](https://github.com/Sndav/FormatFusion/issues)

---

⭐ 如果这个项目对您有帮助，请给我们一个 Star！
