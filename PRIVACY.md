# Privacy

## Data Location

All data stays on your machine. Nothing is uploaded to any external server.

| Data | Location | Accessed By |
|------|----------|-------------|
| Input images | User-specified path | `convert.sh` → `cwebp` |
| Output `.webp` files | Same directory as input | Written by `cwebp` |

## What the Script Reads

- **Image files** at the path you specify (single file or directory)
- **Nothing else** — no system files, no databases, no personal data

## What the Script Does NOT Do

- ❌ Upload data to any external service
- ❌ Access files outside the specified directory
- ❌ Log image content or metadata
- ❌ Phone home or send telemetry
- ❌ Delete or modify original images

## Network Activity

**Zero.** The script has no network connectivity whatsoever. It runs entirely offline.

## Deleting Data

To remove converted `.webp` files:

```bash
# Remove all .webp files in a directory (recursive)
find /path/to/directory -name '*.webp' -delete
```

Your original images are never modified or deleted by the script.
