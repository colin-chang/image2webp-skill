# Security

## Architecture

This is a **local-only shell script** with no network connectivity. All processing happens on your machine.

## Attack Surface

| Vector | Risk | Mitigation |
|--------|------|------------|
| Malicious input path | Low | The script only processes image files passed as arguments. `cwebp` validates input files and rejects non-image data. |
| `cwebp` binary | Low | `cwebp` is Google's official WebP encoder, installed via Homebrew (`brew install webp`). It's a well-audited, widely-used tool. |
| Shell injection via filename | Low | The script uses `find -print0` + `while read -r -d ''` to safely handle filenames with spaces and special characters. |

## What the Script Does

- **Reads** image files at the specified path
- **Writes** `.webp` files to the same directory
- **Nothing else** — no network calls, no data upload, no external communication

## What the Script Does NOT Do

- ❌ Connect to any network service
- ❌ Read files outside the specified directory
- ❌ Delete or modify original files
- ❌ Execute arbitrary code from image metadata
- ❌ Phone home or send telemetry

## Recommendations

1. **Keep cwebp updated**: `brew upgrade webp`
2. **Review the script**: `scripts/convert.sh` is ~70 lines of bash. Read it before using.
3. **Trust your input**: Only convert images from sources you trust.
