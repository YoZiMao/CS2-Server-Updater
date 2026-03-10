#!/bin/bash

# ================= 配置区域 =================
# 服务器安装路径 (建议使用绝对路径)
# 例如：/home/steam/cs2_server 或 /opt/cs2_server
SERVER_PATH="/home/steam/cs2_server"

# CS2 App ID
APP_ID=730

# SteamCMD 路径 (如果已全局安装可填 steamcmd，如果在当前目录填 ./steamcmd.sh)
STEAMCMD_PATH="./steamcmd.sh"
# ===========================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo -e "${GREEN}正在启动 SteamCMD 更新 CS2 服务器...${NC}"
echo "目标安装目录：$SERVER_PATH"
echo "App ID: $APP_ID"
echo "========================================"
echo ""

# 1. 检查 SteamCMD 是否存在
if [ ! -f "$STEAMCMD_PATH" ]; then
    # 尝试检查是否全局安装了 steamcmd
    if command -v steamcmd &> /dev/null; then
        STEAMCMD_PATH="steamcmd"
        echo -e "${YELLOW}[提示] 使用系统全局安装的 steamcmd${NC}"
    else
        echo -e "${RED}[错误] 未找到 steamcmd.sh！${NC}"
        echo "请确保 steamcmd.sh 与此脚本在同一目录下，或已全局安装。"
        echo "下载链接：https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
        exit 1
    fi
fi

# 2. 确保服务器目录存在
if [ ! -d "$SERVER_PATH" ]; then
    echo -e "${YELLOW}[提示] 目录不存在，正在创建：$SERVER_PATH${NC}"
    mkdir -p "$SERVER_PATH"
fi

# 3. 执行更新 (添加 validate 验证文件完整性)
# 使用 bash 执行 steamcmd.sh 以确保兼容性
"$STEAMCMD_PATH" +force_install_dir "$SERVER_PATH" +login anonymous +app_update $APP_ID validate +quit

# 4. 检查执行结果
if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}[警告] SteamCMD 执行完毕，但检测到错误。${NC}"
    echo "请检查网络连接、磁盘空间或 32 位库依赖。"
    exit 1
else
    echo ""
    echo -e "${GREEN}[成功] 服务器文件更新/验证完成！${NC}"
fi

echo ""
echo "按任意键退出..."
read -n 1 -s
