#!/bin/bash
# 开发环境启动脚本

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
LOG_FILE="$LOG_DIR/dev-$(date +%Y%m%d-%H%M%S).log"

echo "=========================================="
echo "启动 Next.js 开发服务器"
echo "项目目录: $PROJECT_ROOT"
echo "日志文件: $LOG_FILE"
echo "=========================================="

# 检查 node_modules 是否存在
if [ ! -d "node_modules" ]; then
    echo "正在安装依赖..."
    npm install 2>&1 | tee -a "$LOG_FILE"
fi

# 启动开发服务器
echo "启动开发服务器..."
npm run dev 2>&1 | tee -a "$LOG_FILE"
