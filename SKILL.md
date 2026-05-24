---
name: image2webp-skill
description: 将 JPG/PNG 图片批量转换为 WebP 格式。支持单文件或递归目录。依赖系统已安装的 cwebp 工具。
trigger:
  - keywords: [转换, webp, 图片压缩, 转格式, convert, to webp]
  - patterns:
    - "把.*转.*webp"
    - "convert.*to.*webp"
    - "图片.*webp"
    - "压缩.*图片"
version: 1.0.0
repository: https://github.com/colin-chang/image2webp-skill
---

# Image to WebP Converter

批量图片转 WebP 格式工具，基于 Google cwebp 编码器。

## 前置条件

- `cwebp` 已安装（Homebrew: `brew install webp`）
- macOS / Linux 环境

## 使用方式

用户提供**文件路径**或**目录路径**，Skill 自动判断：

| 输入类型 | 行为 |
|----------|------|
| 单文件 (`.jpg`/`.jpeg`/`.png`) | 直接转换为同目录下同名 `.webp` 文件 |
| 目录 | 递归扫描目录下所有 JPG/JPEG/PNG，批量转换为 `.webp` |

### 对话示例

```
用户: 把 ~/Downloads/photo.jpg 转成 webp
用户: 把 ~/Desktop/screenshots/ 目录下图片全转 webp
用户: 将 ~/Pictures/ 转 webp，质量 90
```

## 执行流程

1. 确认目标路径存在
2. 调用 `scripts/convert.sh <路径> [质量]`
3. 输出转换统计（成功数、失败数、总大小变化）

## 默认参数

- 质量: `80`（用户可指定 0-100）
- 压缩方法: `-m 6`（最慢但最小）
- 多线程: `-mt`（启用）
- 静默模式: `-quiet`

## 输出格式

```
📁 扫描: /path/to/dir
  ✓ photo1.jpg → photo1.webp  (1.2MB → 145KB)
  ✓ photo2.png → photo2.webp  (3.4MB → 480KB)
  ✗ broken.jpg — 转换失败: unsupported format

📊 完成: 2/3 成功, 总大小 4.6MB → 625KB (节省 86.4%)
```

## 注意事项

- 原文件**不会被删除**，WebP 文件生成在同目录
- 已存在同名 `.webp` 会被覆盖
- 支持格式: `.jpg`, `.jpeg`, `.png`
- 不支持 GIF、SVG、BMP 等格式（cwebp 限制）
