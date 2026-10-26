# text-to-cad 一键部署指南

> 第三方部署指南 · 非 text-to-cad 官方仓库。官方项目：[earthtojake/text-to-cad](https://github.com/earthtojake/text-to-cad)
> 内容来自官方文档（2026-10-26）。项目迭代快，请以[官方文档](https://github.com/earthtojake/text-to-cad#-install)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用装 CAD 软件，让百度搭子把 cadgen 装好，说一句话就能出 3D 模型。

⚠️ 依赖 uv（会自动准备 Python 3.11+）；首次运行要下载 CAD 运行时，需要网络与磁盘。主要面向 Claude Code / Codex / Cursor / Gemini / Grok 这类支持插件或技能的 Agent；百度搭子通过 MCP 接入。默认开启匿名使用统计，可用 `uvx cadgen telemetry off` 关闭。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/text-to-cad-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会先确保 uv 可用，再用 uvx 拉取 cadgen 0.7.26 并确认版本，然后提示 MCP 注册方式，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## text-to-cad 是什么？

text-to-cad 是开源的文字生成 3D 模型与制造检查的 Agent 插件（协议：MIT，<img src="https://img.shields.io/github/stars/earthtojake/text-to-cad?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

把自然语言变成 STEP / GLB / STL / 3MF 模型，附带可制造性检查（DFM）、工程图，以及对接 3D 打印、钣金和 CNC 服务；核心是本地运行的 `cadgen` MCP server 与一组技能。

- 输出：STEP / GLB / STL / 3MF
- 能力：建模、DFM 检查、工程图
- 制造：对接 3D 打印、钣金、CNC 服务
- 接入：Claude Code 插件 / Skills CLI / MCP server
- 预览：浏览器里的 CAD Viewer

（来源：[官方仓库](https://github.com/earthtojake/text-to-cad)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 23.3k stars | 2026-04 建，月增约 6,800 |
| 真能出模型 | STEP / GLB / STL / 3MF 都能导 |
| 不只建模 | 带 DFM 检查、工程图与制造对接 |
| 接入面广 | Claude Code、Codex、Cursor、Gemini、Grok、MCP |
| 本地运行 | cadgen 在本机跑，文件不出本机 |

| 需要注意 | 说明 |
|---|---|
| 依赖 uv | 没用过 uv 的要先装 |
| 首次启动重 | 要下载 CAD 运行时 |
| 受众窄 | 面向机械 / 3D 打印用户 |
| 默认开统计 | 要手动关 |
| Windows 有 DLL 坑 | OCP 依赖 VC++ 运行库 |

> 以上基于官方文档与社区反馈整理（2026-10-26），以官方最新文档为准。

## 快速部署（官方方式）

```bash
command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
uvx --from cadgen==0.7.26 cadgen --version
echo "安装完成：在百度搭子里注册 MCP，command 用 uvx --from cadgen==0.7.26 cadgen mcp"
```

部署步骤来源：[https://github.com/earthtojake/text-to-cad#-install](https://github.com/earthtojake/text-to-cad#-install)

## 验证状态

| 场景 | 状态 |
|---|---|
| PyPI 包 cadgen 最新版 0.7.26、requires_python >=3.11 已核对 | 已验证 2026-10-26 |
| 本机未安装 uv，未实际运行 cadgen | 已核对 2026-10-26 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-26 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-26 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

text-to-cad 的核心就是 `cadgen mcp` 这个本地 MCP server；百度搭子可直接注册。本仓库的 MCP 只提供安装与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-26）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\text-to-cad-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 接入百度搭子（MCP）

```json
{
  "type": "local",
  "command": ["uvx", "--from", "cadgen==0.7.26", "cadgen", "mcp"]
}
```

### 怎么用

1. 描述零件：用途、尺寸、材料、受力或装配关系
2. 让它导出 STEP / STL / 3MF，并做一次 DFM 检查
3. 要看模型就打开返回的 CAD Viewer 链接
4. 要加工时，再让它生成工程图或对接打印 / 钣金 / CNC 服务

### 关闭统计

```sh
uvx --from cadgen==0.7.26 cadgen telemetry off
```

### Windows 注意

如果出现 `ImportError: DLL load failed while importing OCP`，按官方 Troubleshooting 安装 VC++ 运行库后重试。

> ⚠️ 生成结果只是设计草稿：上机床、开模或批量打印前，必须由人复核尺寸、公差与材料。

## 常见坑

- `uv` 找不到：先装 uv，再重开终端让 PATH 生效
- MCP 起不来：用 `uvx --from cadgen==0.7.26 cadgen mcp` 完整命令排查
- 首次很慢：要下载 CAD 运行时，不是卡死
- Windows OCP DLL 报错：安装 VC++ 运行库
- 模型尺寸不对：描述里给明确单位与关键尺寸，别只说「大一点」
- 不想上报统计：`uvx --from cadgen==0.7.26 cadgen telemetry off`
- 别直接上机床：生成结果必须人工复核

## 免责声明

本仓库为第三方指南，与 text-to-cad 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-26），项目迭代快，请以[官方文档](https://github.com/earthtojake/text-to-cad#-install)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
