# Skit Windows 安装脚本
# PowerShell 版本，适用于 Windows 10/11

param(
    [string]$InstallDir = "$env:USERPROFILE\bin",
    [switch]$Global = $false
)

$ErrorActionPreference = "Stop"

# 常量定义
$REPO = "Sndav/Skit"
$BINARY_NAME = "skit.exe"

# 如果指定了全局安装
if ($Global) {
    $InstallDir = "$env:ProgramFiles\Skit"
}

# 颜色输出函数
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    
    $colors = @{
        "Red" = [ConsoleColor]::Red
        "Green" = [ConsoleColor]::Green
        "Yellow" = [ConsoleColor]::Yellow
        "Blue" = [ConsoleColor]::Blue
        "White" = [ConsoleColor]::White
    }
    
    Write-Host $Message -ForegroundColor $colors[$Color]
}

function Log-Info {
    param([string]$Message)
    Write-ColorOutput "[INFO] $Message" "Blue"
}

function Log-Success {
    param([string]$Message)
    Write-ColorOutput "[SUCCESS] $Message" "Green"
}

function Log-Warning {
    param([string]$Message)
    Write-ColorOutput "[WARNING] $Message" "Yellow"
}

function Log-Error {
    param([string]$Message)
    Write-ColorOutput "[ERROR] $Message" "Red"
}

# 检测系统架构
function Get-SystemArchitecture {
    $arch = $env:PROCESSOR_ARCHITECTURE
    switch ($arch) {
        "AMD64" { return "x86_64" }
        "ARM64" { return "aarch64" }
        default {
            Log-Error "不支持的架构: $arch"
            exit 1
        }
    }
}

# 获取最新版本
function Get-LatestVersion {
    Log-Info "获取最新版本信息..."
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO/releases/latest"
        $version = $response.tag_name
        Log-Info "最新版本: $version"
        return $version
    }
    catch {
        Log-Error "无法获取最新版本信息: $_"
        exit 1
    }
}

# 下载文件
function Download-File {
    param(
        [string]$Url,
        [string]$OutputPath
    )
    
    Log-Info "下载文件: $Url"
    
    try {
        # 使用 .NET WebClient 进行下载，显示进度
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($Url, $OutputPath)
        Log-Success "下载完成"
    }
    catch {
        Log-Error "下载失败: $_"
        exit 1
    }
}

# 解压ZIP文件
function Extract-ZipFile {
    param(
        [string]$ZipPath,
        [string]$ExtractPath
    )
    
    Log-Info "解压文件..."
    
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipPath, $ExtractPath)
        Log-Success "解压完成"
    }
    catch {
        Log-Error "解压失败: $_"
        exit 1
    }
}

# 创建目录
function Ensure-Directory {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        Log-Info "创建目录: $Path"
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

# 添加到PATH
function Add-ToPath {
    param([string]$Directory)
    
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    
    if ($currentPath -notlike "*$Directory*") {
        Log-Info "添加 $Directory 到 PATH"
        $newPath = "$currentPath;$Directory"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Log-Success "已添加到 PATH（重启终端后生效）"
    } else {
        Log-Info "$Directory 已在 PATH 中"
    }
}

# 验证安装
function Test-Installation {
    param([string]$BinaryPath)
    
    Log-Info "验证安装..."
    
    if (Test-Path $BinaryPath) {
        try {
            $version = & $BinaryPath --version 2>&1
            Log-Success "✓ Skit 已成功安装"
            Log-Info "版本信息: $version"
            return $true
        }
        catch {
            Log-Warning "安装的文件可能有问题"
            return $false
        }
    } else {
        Log-Error "安装失败：未找到可执行文件"
        return $false
    }
}

# 显示使用说明
function Show-Usage {
    Write-Host ""
    Write-ColorOutput "🎉 Skit 安装完成！" "Green"
    Write-Host ""
    Write-Host "使用示例:"
    Write-Host "  # 格式化JSON"
    Write-Host "  skit format --clip --format json --back"
    Write-Host ""
    Write-Host "  # 获取外网IP"
    Write-Host "  skit ip"
    Write-Host ""
    Write-Host "  # 获取详细IP信息"
    Write-Host "  skit ip --verbose"
    Write-Host ""
    Write-Host "  # 查看帮助"
    Write-Host "  skit --help"
    Write-Host ""
    Write-Host "更多信息请访问: https://github.com/$REPO"
    Write-Host ""
    Write-ColorOutput "注意：如果命令未找到，请重启 PowerShell 或命令提示符" "Yellow"
}

# 主函数
function Main {
    Write-Host ""
    Write-ColorOutput "╔══════════════════════════════════════╗" "Blue"
    Write-ColorOutput "║           Skit 安装脚本              ║" "Blue"
    Write-ColorOutput "║      开发者工具集一键安装            ║" "Blue"
    Write-ColorOutput "╚══════════════════════════════════════╝" "Blue"
    Write-Host ""
    
    # 检测架构
    $arch = Get-SystemArchitecture
    Log-Info "检测到架构: $arch"
    
    # 获取最新版本
    $version = Get-LatestVersion
    
    # 构建下载URL
    $filename = "skit-windows-$arch.zip"
    $downloadUrl = "https://github.com/$REPO/releases/download/$version/$filename"
    
    # 创建临时目录
    $tempDir = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString()
    Ensure-Directory $tempDir
    
    try {
        # 下载文件
        $zipPath = Join-Path $tempDir $filename
        Download-File $downloadUrl $zipPath
        
        # 解压文件
        $extractPath = Join-Path $tempDir "extracted"
        Extract-ZipFile $zipPath $extractPath
        
        # 确保安装目录存在
        Ensure-Directory $InstallDir
        
        # 复制可执行文件
        $sourcePath = Join-Path $extractPath $BINARY_NAME
        $targetPath = Join-Path $InstallDir $BINARY_NAME
        
        if (Test-Path $sourcePath) {
            Copy-Item $sourcePath $targetPath -Force
            Log-Success "文件已复制到: $targetPath"
        } else {
            Log-Error "未找到可执行文件: $sourcePath"
            exit 1
        }
        
        # 添加到PATH（仅用户安装）
        if (-not $Global) {
            Add-ToPath $InstallDir
        }
        
        # 验证安装
        if (Test-Installation $targetPath) {
            Show-Usage
        }
    }
    finally {
        # 清理临时文件
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# 检查管理员权限（全局安装需要）
if ($Global) {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Log-Error "全局安装需要管理员权限"
        Log-Info "请以管理员身份运行 PowerShell，或使用用户安装（不加 -Global 参数）"
        exit 1
    }
}

# 运行主函数
Main
