#!/usr/bin/env bash
set -euo pipefail
# text-to-cad 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/earthtojake/text-to-cad#-install
# 更新日期：2026-10-28
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }

mkdir -p .download
cd .download

command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
uvx --from cadgen==0.8.1 cadgen --version
echo "安装完成：在百度搭子里注册 MCP，command 用 uvx --from cadgen==0.8.1 cadgen mcp"

echo ""

echo "安装完成：在百度搭子里注册 MCP（type=local，command 用 uvx --from cadgen==0.8.1 cadgen mcp），之后直接描述要做的零件"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/earthtojake/text-to-cad#-install"
