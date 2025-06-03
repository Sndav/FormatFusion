#!/bin/bash
set -e

# Skit 一键安装脚本
# 支持 macOS, Linux (x86_64, ARM64)
# Windows 用户请使用 PowerShell 脚本

REPO="Sndav/Skit"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="skit"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检测操作系统和架构
detect_platform() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)
    
    case $os in
        linux*)
            OS="linux"
            ;;
        darwin*)
            OS="macos"
            ;;
        *)
            log_error "不支持的操作系统: $os"
            log_info "请手动下载适合您系统的版本: https://github.com/${REPO}/releases"
            exit 1
            ;;
    esac
    
    case $arch in
        x86_64|amd64)
            ARCH="x86_64"
            ;;
        arm64|aarch64)
            ARCH="aarch64"
            ;;
        *)
            log_error "不支持的架构: $arch"
            log_info "请手动下载适合您系统的版本: https://github.com/${REPO}/releases"
            exit 1
            ;;
    esac
    
    PLATFORM="${OS}-${ARCH}"
    log_info "检测到平台: ${PLATFORM}"
}

# 获取最新版本
get_latest_version() {
    log_info "获取最新版本信息..."
    
    if command -v curl >/dev/null 2>&1; then
        VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
    elif command -v wget >/dev/null 2>&1; then
        VERSION=$(wget -qO- "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
    else
        log_error "需要 curl 或 wget 来下载文件"
        exit 1
    fi
    
    if [ -z "$VERSION" ]; then
        log_error "无法获取最新版本信息"
        exit 1
    fi
    
    log_info "最新版本: ${VERSION}"
}

# 构建下载URL
build_download_url() {
    FILENAME="${BINARY_NAME}-${PLATFORM}.tar.gz"
    DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${FILENAME}"
    log_info "下载地址: ${DOWNLOAD_URL}"
}

# 创建临时目录
create_temp_dir() {
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    log_info "创建临时目录: ${TEMP_DIR}"
}

# 下载并解压
download_and_extract() {
    log_info "下载 ${FILENAME}..."
    
    cd "$TEMP_DIR"
    
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$DOWNLOAD_URL" -o "$FILENAME"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$DOWNLOAD_URL" -O "$FILENAME"
    else
        log_error "需要 curl 或 wget 来下载文件"
        exit 1
    fi
    
    if [ ! -f "$FILENAME" ]; then
        log_error "下载失败"
        exit 1
    fi
    
    log_info "解压文件..."
    tar -xzf "$FILENAME"
    
    if [ ! -f "$BINARY_NAME" ]; then
        log_error "解压后未找到可执行文件: ${BINARY_NAME}"
        exit 1
    fi
    
    # 添加执行权限
    chmod +x "$BINARY_NAME"
}

# 安装二进制文件
install_binary() {
    log_info "安装 ${BINARY_NAME} 到 ${INSTALL_DIR}..."
    
    # 检查是否需要 sudo
    if [ -w "$INSTALL_DIR" ]; then
        cp "$BINARY_NAME" "$INSTALL_DIR/"
    else
        if command -v sudo >/dev/null 2>&1; then
            sudo cp "$BINARY_NAME" "$INSTALL_DIR/"
        else
            log_error "没有权限写入 ${INSTALL_DIR}，且未找到 sudo 命令"
            log_info "请手动将 ${TEMP_DIR}/${BINARY_NAME} 复制到您的 PATH 目录中"
            exit 1
        fi
    fi
    
    # 验证安装
    if [ -f "${INSTALL_DIR}/${BINARY_NAME}" ]; then
        log_success "安装成功！"
    else
        log_error "安装失败"
        exit 1
    fi
}

# 验证安装
verify_installation() {
    log_info "验证安装..."
    
    if command -v "$BINARY_NAME" >/dev/null 2>&1; then
        VERSION_OUTPUT=$("$BINARY_NAME" --version 2>&1 || echo "")
        log_success "✓ ${BINARY_NAME} 已成功安装"
        log_info "版本信息: ${VERSION_OUTPUT}"
    else
        log_warning "⚠ ${BINARY_NAME} 未在 PATH 中找到"
        log_info "您可能需要重新启动终端或添加 ${INSTALL_DIR} 到您的 PATH"
    fi
}

# 显示使用说明
show_usage() {
    echo ""
    echo -e "${GREEN}🎉 Skit 安装完成！${NC}"
    echo ""
    echo "使用示例:"
    echo "  # 格式化JSON"
    echo "  ${BINARY_NAME} format --clip --format json --back"
    echo ""
    echo "  # 获取外网IP"
    echo "  ${BINARY_NAME} ip"
    echo ""
    echo "  # 获取详细IP信息"
    echo "  ${BINARY_NAME} ip --verbose"
    echo ""
    echo "  # 查看帮助"
    echo "  ${BINARY_NAME} --help"
    echo ""
    echo "更多信息请访问: https://github.com/${REPO}"
}

# 主函数
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║           Skit 安装脚本              ║"
    echo "║      开发者工具集一键安装            ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    
    detect_platform
    get_latest_version
    build_download_url
    create_temp_dir
    download_and_extract
    install_binary
    verify_installation
    show_usage
}

# 检查是否以 root 身份运行（不推荐）
if [ "$EUID" -eq 0 ]; then
    log_warning "不推荐以 root 身份运行此脚本"
    read -p "继续安装？(y/N) " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 运行主函数
main "$@"
