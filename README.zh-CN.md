# image2webp-skill

> 🖼️ **AI Agent Skill** — 一键将 JPG/PNG 图片批量转换为 WebP 格式，只需一句对话即可完成。
>
> 适用于 **Hermes Agent**，或任何运行在 macOS/Linux 上的自动化脚本。

[![Skill](https://img.shields.io/badge/type-Agent%20Skill-blue)](SKILL.md)
[![Platform: macOS/Linux](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/colin-chang/image2webp-skill)](https://github.com/colin-chang/image2webp-skill/releases)

---

[English](README.md)

## 这是什么？

**image2webp-skill** 是一个 **AI Agent Skill**，用来把图片转成 WebP 格式。你对 Agent 说一句「把这些图转成 WebP」，剩下的它全搞定——单张也行，整个文件夹也行，递归扫描，附赠压缩统计。

它把 Google 的 `cwebp` 编码器包装成一个简单、对 Agent 友好的接口。不用打开 Pixelmator、不用拖拽、不用一张张手动导出。指定路径，然后去喝茶。

## 它解决什么问题？

手动转 WebP 太痛苦了：

- 打开 Pixelmator（或其他编辑器）
- 文件 → 导出 → WebP
- 调质量滑块
- 保存
- 然后对每一张图重复以上步骤……

当你有 20 张截图时，这简直是酷刑。**image2webp-skill** 把它变成一句话的事：

> 「把 `~/Downloads/` 转成 WebP」

搞定。文件夹里所有 JPG/PNG 递归转换，最后给你一份前后体积对比。

## 架构

```
你（通过 AI Agent）
    │  "把这个文件夹转成 WebP"
    ▼
Skill: image2webp-skill
    │  scripts/convert.sh <路径> [质量]
    ▼
cwebp（Google WebP 编码器，通过 Homebrew 安装）
    │  读取 JPEG/PNG/TIFF
    │  编码为 WebP
    ▼
.webp 文件写入原目录
```

没有网络请求，没有外部服务。就是 bash 脚本 → `cwebp` → 完成。

## 快速开始

### 前置条件

```bash
brew install webp
```

就这一条命令。`cwebp` 包含在 Google 的 `webp` 包里。

### 安装 Skill

```bash
# 克隆到 Hermes skills 目录
cd ~/.hermes/skills/custom/
git clone https://github.com/colin-chang/image2webp-skill.git image2webp-skill
```

### 使用方式（通过 AI Agent）

```
用户：把 ~/Desktop/screenshot.png 转成 webp
用户：把 ~/Downloads/blog-images/ 目录转 webp，质量 90
用户：批量把 ~/Pictures/ 里所有图片转成 webp
```

Agent 加载 Skill 后运行 `scripts/convert.sh`，然后汇报结果：

```
📁 扫描: /Users/colin/Downloads

  ✓ photo1.jpg → photo1.webp  (1.2MB → 145KB, -88%)
  ✓ photo2.png → photo2.webp  (3.4MB → 480KB, -86%)
  ✓ photo3.jpg → photo3.webp  (856KB → 98KB, -89%)

📊 完成: 3/3 成功
```

### 命令行使用（不需要 Agent）

```bash
# 单文件
./scripts/convert.sh ~/Desktop/photo.png

# 整个目录（递归）
./scripts/convert.sh ~/Downloads/ 80

# 自定义质量
./scripts/convert.sh ~/Pictures/ 90
```

## 功能特性

| 功能 | 说明 |
|------|------|
| 🎯 **单文件转换** | 转一张图：`convert.sh photo.jpg` |
| 📁 **目录批量** | 递归转换文件夹内所有图片 |
| 🧵 **多线程加速** | `-mt` 参数启用并行编码 |
| 📊 **压缩统计** | 显示转换前后体积和压缩率 |
| 🔒 **不删原图** | 原文件绝不会被删除或修改 |
| 🌐 **完全离线** | 零网络请求，全部本地运行 |
| 🎛️ **质量可调** | `-q 0-100`（默认 80） |

## 支持的格式

| 输入 | 输出 | 备注 |
|------|------|------|
| JPEG（`.jpg`、`.jpeg`） | `.webp` | ✅ 完全支持 |
| PNG（`.png`） | `.webp` | ✅ 完全支持，保留透明通道 |
| TIFF（`.tiff`、`.tif`） | `.webp` | ✅ cwebp 支持 |
| GIF、SVG、BMP、HEIC | — | ❌ cwebp 编码器不支持 |

## 默认参数

| 参数 | 值 | 说明 |
|------|-----|------|
| 质量（`-q`） | `80` | 0-100，越高画质越好、文件越大 |
| 压缩方法（`-m`） | `6` | 0（最快）到 6（最慢最小） |
| 多线程（`-mt`） | 开启 | 使用全部 CPU 核心 |
| 输出模式（`-quiet`） | 开启 | 只显示汇总，不显示编码器逐行输出 |

## 文档

| 文档 | 说明 |
|------|------|
| [SKILL.md](SKILL.md) | 完整 Skill 参考（触发条件、工作流、输出格式） |
| [SECURITY.md](SECURITY.md) | 安全性分析和攻击面评估 |
| [PRIVACY.md](PRIVACY.md) | 数据处理和隐私承诺 |

## 平台支持

- **macOS** — 已在 macOS 15 (Sequoia) 测试
- **Linux** — 理论上支持（需通过包管理器安装 `cwebp`）
- `cwebp` 安装方式：
  - macOS：`brew install webp`
  - Ubuntu/Debian：`apt install webp`
  - Fedora：`dnf install libwebp-tools`

## Agent 兼容性

此 Skill **与 Agent 平台无关**——它就是一个 shell 脚本。任何能执行 shell 命令的 Agent 平台都能用：

| Agent / 平台 | 集成方式 |
|-------------|---------|
| **Hermes Agent** | 原生 Skill — 放入 `~/.hermes/skills/custom/` |
| **Claude Code** | 加入 `CLAUDE.md`，通过 `terminal` 调用 |
| **OpenCode / Codex** | 加入项目指令，通过 shell 调用 |
| **任何 shell 脚本** | `./scripts/convert.sh /path/to/images` |

## 许可证

MIT — 详见 [LICENSE](LICENSE)

## 常见问题

**Q: 会删除我的原图吗？**
A: 不会。原文件绝不会被修改或删除。`.webp` 文件与原文件放在同一目录下。

**Q: 能调整压缩质量吗？**
A: 能。传入第二个参数：`./scripts/convert.sh ~/Photos/ 90`（0-100，默认 80）。

**Q: 能处理子文件夹吗？**
A: 能。目录模式会递归扫描所有子文件夹。

**Q: 如果同名 `.webp` 文件已存在会怎样？**
A: 会被覆盖。脚本不会跳过已存在的文件。

**Q: 能转 GIF 或 SVG 吗？**
A: 不能。`cwebp` 只支持 JPEG、PNG、TIFF 和 WebP 作为输入格式。

**Q: 为什么压缩完的图片比原图大？**
A: 如果原图已经是高度压缩的 JPEG，WebP 在低画质下可能反而更大。试试提高质量参数（如 `-q 90`），或者原图本身就很小（几 KB），此时转 WebP 无意义。
