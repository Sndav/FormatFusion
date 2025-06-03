# Skit 安装指南

Skit 是一个强大的开发者工具集，支持文本格式化、网络工具等功能。

## 🚀 快速安装

### macOS / Linux

复制并运行以下命令：

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Sndav/Skit/master/install.sh)"
```

### Windows

在 PowerShell 中运行：

```powershell
iex (iwr -useb https://raw.githubusercontent.com/Sndav/Skit/master/install.ps1).Content
```

对于 Windows 用户，您也可以：

1. **用户安装（推荐）**: 默认安装到用户目录
2. **全局安装**: 使用 `-Global` 参数，需要管理员权限

```powershell
# 全局安装（需要管理员权限）
iex (iwr -useb https://raw.githubusercontent.com/Sndav/Skit/master/install.ps1).Content -Global
```

## 📦 手动安装

如果您的网络环境无法使用一键安装，请：

1. 访问 [Releases 页面](https://github.com/Sndav/Skit/releases)
2. 下载适合您系统的版本
3. 解压并将可执行文件放入 PATH 目录

## ✅ 验证安装

安装完成后，运行以下命令验证：

```bash
skit --version
```

## 🎯 快速开始

```bash
# 格式化 JSON
skit format --clip --format json --back

# 获取外网 IP
skit ip

# 查看帮助
skit --help
```

## 🔧 故障排除

### 命令未找到

如果安装后提示 "command not found"：

1. **重启终端**: 环境变量更新需要重启终端生效
2. **检查 PATH**: 确认安装目录已添加到 PATH
3. **手动添加**: 将安装目录手动添加到系统 PATH

### Windows 执行策略错误

如果 PowerShell 提示执行策略错误：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 网络连接问题

如果无法下载安装脚本：

1. 检查网络连接
2. 使用代理或VPN
3. 选择手动安装方式

## 📞 获取帮助

- 🐛 [报告问题](https://github.com/Sndav/Skit/issues)
- 📖 [查看文档](https://github.com/Sndav/Skit/blob/master/README.md)
- 📧 [联系作者](mailto:i@sndav.org)
