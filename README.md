# 🛠️ Skit

[![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](https://www.rust-lang.org/)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg?style=for-the-badge)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/Sndav/Skit/ci.yml?branch=main&style=for-the-badge&label=CI)](https://github.com/Sndav/Skit/actions)
[![Release](https://img.shields.io/github/v/release/Sndav/Skit?style=for-the-badge)](https://github.com/Sndav/Skit/releases)

> 🚀 一个强大的开发者工具集，集成文本格式化、网络工具、截图等常用开发功能

Skit 是一个用 Rust 编写的命令行工具，专为开发者日常工作设计。它集成了多种常用的开发工具功能，包括文本格式化、IP 查询、截图工具等，让您的开发工作更加高效便捷。

## ✨ 特性

- 🎯 **文本格式化**: JSON、YAML、XML 格式的智能识别和美化
- 🌐 **网络工具**: 快速获取外网IP地址和网络信息
- 📸 **截图工具**: 便捷的屏幕截图功能（计划中）
- 📋 **剪贴板集成**: 直接从剪贴板读取和写入内容
- 📁 **文件处理**: 支持文件输入输出操作
- ⚡ **高性能**: 基于 Rust 构建，处理速度极快
- 🛡️ **错误处理**: 完善的错误处理和日志记录
- 🔧 **灵活配置**: 支持多种输入输出方式

## 🚀 快速开始

### 安装

#### 一键安装（推荐）

**macOS / Linux:**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Sndav/Skit/master/install.sh)"
```

**Windows (PowerShell):**
```powershell
iex (iwr -useb https://raw.githubusercontent.com/Sndav/Skit/master/install.ps1).Content
```

> 💡 **安装提示**: 
> - 安装脚本会自动检测您的系统架构并下载对应版本
> - Linux/macOS 用户安装到 `/usr/local/bin`，Windows 用户安装到用户目录
> - 如遇到权限问题，脚本会自动使用 `sudo`（Linux/macOS）或提示管理员权限（Windows）
> - 详细安装说明请查看 [INSTALL.md](INSTALL.md)

#### 从发布版本安装

#### 手动安装

如果一键安装遇到问题，您可以手动下载安装：

1. 前往 [Releases 页面](https://github.com/Sndav/Skit/releases)
2. 下载适合您操作系统的版本：
   - **Linux x86_64**: `skit-linux-x86_64.tar.gz`
   - **Linux ARM64**: `skit-linux-aarch64.tar.gz`
   - **macOS x86_64**: `skit-macos-x86_64.tar.gz`
   - **macOS ARM64 (Apple Silicon)**: `skit-macos-aarch64.tar.gz`
   - **Windows x86_64**: `skit-windows-x86_64.zip`

3. 解压并安装：

**Linux/macOS**:
```bash
tar -xzf skit-*.tar.gz
sudo mv skit /usr/local/bin/
```

**Windows**:
解压 zip 文件，将 `skit.exe` 放到 PATH 目录中。

**安装选项说明:**
- **一键安装**: 自动下载最新版本并安装到系统PATH
- **手动安装**: 适合有特殊需求或网络环境受限的用户
- **源码编译**: 适合开发者或需要自定义编译选项的用户

#### 从源码编译

确保您已安装 Rust 工具链，然后克隆并构建项目：

```bash
git clone https://github.com/Sndav/Skit
cd Skit
cargo build --release
```

### 基本用法

#### 文本格式化

##### 从剪贴板格式化 JSON
```bash
# 从剪贴板读取内容，格式化为 JSON，并输出到控制台
skit format --clip --format json

# 格式化后直接复制回剪贴板
skit format --clip --format json --back
```

##### 格式化文件
```bash
# 格式化文件并输出到控制台
skit format --input data.json --format json

# 格式化文件并保存到新文件
skit format --input data.json --format json --output formatted.json
```

##### YAML 和 XML 处理
```bash
# 格式化 YAML 文件
skit format --input config.yml --format yaml --output config_formatted.yml

# 格式化 XML 文件
skit format --input document.xml --format xml --output document_formatted.xml
```

#### 网络工具

##### 获取外网IP
```bash
# 获取当前外网IP地址
skit ip
```

## 📖 命令行参数

### format 子命令

用于格式化文本数据：

| 参数 | 短参数 | 描述 | 示例 |
|------|--------|------|------|
| `--clip` | `-c` | 使用剪贴板作为输入源 | `-c` |
| `--input` | `-i` | 指定输入文件路径 | `-i data.json` |
| `--format` | `-f` | 指定输出格式 (json/yaml/xml) | `-f json` |
| `--output` | `-o` | 指定输出文件路径 | `-o result.json` |
| `--back` | `-b` | 将格式化结果复制回剪贴板 | `-b` |

### ip 子命令

用于获取网络IP信息：

## 🎯 使用场景

### 开发调试
```bash
# 快速美化 API 响应的 JSON 数据
curl -s https://api.example.com/data | pbcopy
skit format -c -f json -b
```

### 网络诊断
```bash
skit ip
```

### 配置文件整理
```bash
# 格式化项目配置文件
skit format -i .github/workflows/ci.yml -f yaml -o .github/workflows/ci_formatted.yml
```

### 数据转换
```bash
# 处理 XML 配置文件
skit format -i config.xml -f xml -o config_formatted.xml
```

## 🏗️ 项目结构

```
Skit/
├── src/
│   ├── main.rs              # 主程序入口和命令行处理
│   └── commands/
│       ├── mod.rs           # 命令模块定义
│       ├── format/          # 文本格式化功能
│       │   ├── mod.rs
│       │   └── formater.rs  # 格式化核心逻辑
│       ├── ip/              # IP查询功能（计划中）
│       └── screenshot/      # 截图功能（计划中）
├── Cargo.toml               # 项目依赖配置
├── Cargo.lock               # 依赖锁定文件
├── README.md                # 项目说明文档
└── LICENSE                  # 项目许可证
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
- [ ] 添加网络延迟测试功能
- [ ] 实现屏幕截图工具
- [ ] 添加配置文件支持
- [ ] 实现格式自动检测
- [ ] 添加批量文件处理
- [ ] 支持自定义格式化规则
- [ ] 添加系统信息查看功能
- [ ] 实现文件哈希计算
- [ ] 添加颜色代码转换工具

## 📞 联系我们

如果您有任何问题或建议，请通过以下方式联系我们：

- 📧 Email: i@sndav.org
- 🐛 Issues: [GitHub Issues](https://github.com/Sndav/Skit/issues)

---

⭐ 如果这个项目对您有帮助，请给我们一个 Star！
