#!/bin/bash
# ============================================================
# Image to WebP Converter
# 用法: convert.sh <文件或目录路径> [质量(0-100)]
# ============================================================
set -euo pipefail

# ——— 参数解析 ———
INPUT="${1:-}"
QUALITY="${2:-80}"
CWEBP="/opt/homebrew/bin/cwebp"

# ——— 参数校验 ———
if [ -z "$INPUT" ]; then
    echo "Usage: convert.sh <file_or_directory> [quality]"
    exit 1
fi

INPUT="$(realpath "$INPUT" 2>/dev/null || echo "$INPUT")"

if [ ! -e "$INPUT" ]; then
    echo "❌ 路径不存在: $INPUT"
    exit 1
fi

if ! command -v "$CWEBP" &>/dev/null; then
    echo "❌ cwebp 未找到，请先安装: brew install webp"
    exit 1
fi

# ——— 转换单文件 ———
convert_file() {
    local file="$1"
    local out="${file%.*}.webp"

    if "$CWEBP" -q "$QUALITY" -m 6 -mt -quiet "$file" -o "$out" 2>/dev/null; then
        local in_size
        local out_size
        in_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        out_size=$(stat -f%z "$out" 2>/dev/null || stat -c%s "$out" 2>/dev/null)
        local reduction=$(( 100 - out_size * 100 / in_size ))
        echo "  ✓ $(basename "$file") → $(basename "$out")  ($(numfmt --to=iec "$in_size" 2>/dev/null || echo "${in_size}B") → $(numfmt --to=iec "$out_size" 2>/dev/null || echo "${out_size}B"), -${reduction}%)"
        return 0
    else
        echo "  ✗ $(basename "$file") — 转换失败"
        return 1
    fi
}

# ——— 入口 ———
SUCCESS=0
FAIL=0

if [ -f "$INPUT" ]; then
    # 单文件模式
    ext="${INPUT##*.}"
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    case "$ext_lower" in
        jpg|jpeg|png|tiff|tif)
            echo "🖼  转换单文件: $(basename "$INPUT")"
            if convert_file "$INPUT"; then
                SUCCESS=$((SUCCESS + 1))
            else
                FAIL=$((FAIL + 1))
            fi
            ;;
        *)
            echo "❌ 不支持的格式: .$ext (支持 jpg/jpeg/png/tiff)"
            exit 1
            ;;
    esac
elif [ -d "$INPUT" ]; then
    # 目录模式 — 递归扫描
    echo "📁 扫描: $INPUT"
    echo ""

    while IFS= read -r -d '' file; do
        if convert_file "$file"; then
            SUCCESS=$((SUCCESS + 1))
        else
            FAIL=$((FAIL + 1))
        fi
    done < <(find "$INPUT" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.tiff' -o -iname '*.tif' \) -print0 2>/dev/null)

    echo ""
    echo "📊 完成: $SUCCESS/$((SUCCESS + FAIL)) 成功"
    if [ "$FAIL" -gt 0 ]; then
        echo "   $FAIL 个文件转换失败"
    fi
else
    echo "❌ 输入既不是文件也不是目录: $INPUT"
    exit 1
fi
