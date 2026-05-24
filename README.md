# image-to-webp

> 🖼️ **AI Agent Skill** — batch convert JPG/PNG images to WebP format instantly, with a single conversation command.
>
> Works with **Hermes Agent**, or any automation script running on macOS/Linux.

[![Skill](https://img.shields.io/badge/type-Agent%20Skill-blue)](SKILL.md)
[![Platform: macOS/Linux](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/colin-chang/image-to-webp-skill)](https://github.com/colin-chang/image-to-webp-skill/releases)

---

[中文版](README.zh-CN.md)

## What is this?

**image-to-webp** is an **AI Agent Skill** that converts images to WebP format. Tell your agent "convert these images to WebP" and it handles the rest — single file or entire directory, recursive, with compression stats.

It wraps Google's `cwebp` encoder into a simple, agent-friendly interface. No GUI, no drag-and-drop, no manual clicking through Pixelmator. Just point it at a path and walk away.

## The Problem It Solves

Converting images to WebP manually is tedious:

- Open Pixelmator (or another editor)
- File → Export → WebP
- Adjust quality slider
- Save
- Repeat for every. single. image.

When you have 20 screenshots, this is soul-crushing. **image-to-webp** makes it a one-line conversation:

> "Convert `~/Downloads/` to WebP"

Done. All JPG/PNG files recursively converted. You get a summary with before/after sizes.

## Architecture

```
You (via AI Agent)
    │  "Convert this folder to WebP"
    ▼
Skill: image-to-webp
    │  scripts/convert.sh <path> [quality]
    ▼
cwebp (Google WebP encoder, via Homebrew)
    │  Reads JPEG/PNG/TIFF
    │  Encodes to WebP
    ▼
.webp files written to same directory
```

No network. No external services. Just a bash script → `cwebp` → done.

## Quick Start

### Prerequisites

```bash
brew install webp
```

That's it. `cwebp` is part of Google's `webp` package.

### Install the Skill

```bash
# Clone into your Hermes skills directory
cd ~/.hermes/skills/custom/
git clone https://github.com/colin-chang/image-to-webp-skill.git image-to-webp
```

### Usage (via AI Agent)

```
User: Convert ~/Desktop/screenshot.png to WebP
User: Convert ~/Downloads/blog-images/ to WebP, quality 90
User: Batch convert all images in ~/Pictures/ to WebP
```

The agent loads the skill, runs `scripts/convert.sh`, and reports back:

```
📁 扫描: /Users/colin/Downloads

  ✓ photo1.jpg → photo1.webp  (1.2MB → 145KB, -88%)
  ✓ photo2.png → photo2.webp  (3.4MB → 480KB, -86%)
  ✓ photo3.jpg → photo3.webp  (856KB → 98KB, -89%)

📊 完成: 3/3 成功
```

### CLI Usage (without an agent)

```bash
# Single file
./scripts/convert.sh ~/Desktop/photo.png

# Entire directory (recursive)
./scripts/convert.sh ~/Downloads/ 80

# With custom quality
./scripts/convert.sh ~/Pictures/ 90
```

## Features

| Feature | Description |
|---------|-------------|
| 🎯 **Single file** | Convert one image: `convert.sh photo.jpg` |
| 📁 **Directory batch** | Recursively convert all images in a folder |
| 🧵 **Multi-threaded** | `-mt` flag enables parallel encoding |
| 📊 **Compression stats** | Shows before/after size and reduction % |
| 🔒 **Non-destructive** | Original files are never deleted |
| 🌐 **Offline** | Zero network calls — everything runs locally |
| 🎛️ **Configurable quality** | `-q 0-100` (default: 80) |

## Supported Formats

| Input | Output | Notes |
|-------|--------|-------|
| JPEG (`.jpg`, `.jpeg`) | `.webp` | ✅ Full support |
| PNG (`.png`) | `.webp` | ✅ Full support, alpha preserved |
| TIFF (`.tiff`, `.tif`) | `.webp` | ✅ Supported by cwebp |
| GIF, SVG, BMP, HEIC | — | ❌ Not supported by cwebp encoder |

## Default Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| Quality (`-q`) | `80` | 0-100, higher = better quality, larger file |
| Compression method (`-m`) | `6` | 0 (fast) to 6 (slowest, smallest file) |
| Multi-threading (`-mt`) | On | Use all CPU cores |
| Output mode (`-quiet`) | On | Only show summary, not per-file encoder output |

## Documentation

| Document | Description |
|----------|-------------|
| [SKILL.md](SKILL.md) | Full skill reference (triggers, workflow, output format) |
| [SECURITY.md](SECURITY.md) | Security considerations and attack surface |
| [PRIVACY.md](PRIVACY.md) | Data handling and privacy guarantees |

## Platform Support

- **macOS** — tested on macOS 15 (Sequoia)
- **Linux** — should work (requires `cwebp` from package manager)
- `cwebp` installed via:
  - macOS: `brew install webp`
  - Ubuntu/Debian: `apt install webp`
  - Fedora: `dnf install libwebp-tools`

## Agent Compatibility

This Skill is **agent-agnostic** — it's a shell script. Any agent platform that can execute shell commands can use it:

| Agent / Platform | Integration |
|------------------|-------------|
| **Hermes Agent** | Native Skill — place in `~/.hermes/skills/custom/` |
| **Claude Code** | Add to `CLAUDE.md`, invoke via `terminal` |
| **OpenCode / Codex** | Add to project instructions, invoke via shell |
| **Any shell script** | `./scripts/convert.sh /path/to/images` |

## License

MIT — see [LICENSE](LICENSE)

## FAQ

**Q: Does this delete my original images?**
A: No. Original files are never modified or deleted. `.webp` files are created alongside the originals.

**Q: Can I adjust the compression quality?**
A: Yes. Pass a second argument: `./scripts/convert.sh ~/Photos/ 90` (0-100, default 80).

**Q: Does it handle subdirectories?**
A: Yes. Directory mode recursively scans all subdirectories.

**Q: What if a `.webp` file already exists?**
A: It will be overwritten. The script doesn't skip existing files.

**Q: Can I convert GIFs or SVGs?**
A: No. `cwebp` only supports JPEG, PNG, TIFF, and WebP as input formats.
