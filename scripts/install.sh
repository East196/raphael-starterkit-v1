#!/bin/bash
# 依赖安装脚本

set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 切换到项目根目录
cd "$PROJECT_ROOT"

# 日志目录
LOG_DIR="$PROJECT_ROOT/logs"
mkdir -p "$LOG_DIR"

# 日志文件
LOG_FILE="$LOG_DIR/install-$(date +%Y%m%d-%H%M%S).log"

echo "=========================================="
echo "安装项目依赖"
echo "项目目录: $PROJECT_ROOT"
echo "日志文件: $LOG_FILE"
echo "=========================================="

npm install 2>&1 | tee -a "$LOG_FILE"

echo "依赖安装完成!"
