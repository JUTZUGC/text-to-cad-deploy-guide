# text-to-cad 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/earthtojake/text-to-cad#-install
# 更新日期：2026-10-28
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) { powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex" }
$env:Path = "$env:USERPROFILE\.local\bin;$env:Path" ; uvx --from cadgen==0.8.1 cadgen --version
Write-Host '安装完成：在百度搭子里注册 MCP（type=local，command=uvx --from cadgen==0.8.1 cadgen mcp）'

Write-Host ''

Write-Host '安装完成：在百度搭子里注册 MCP（type=local，command 用 uvx --from cadgen==0.8.1 cadgen mcp），之后直接描述要做的零件'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/earthtojake/text-to-cad#-install'
