# 7S-06-SIZING: simple_stb

**BACKWASH** | Date: 2026-01-23

## Codebase Metrics

- **Source Files**: 4 .e files
- **Header Files**: 3 .h files (stb headers + wrapper)
- **LOC Estimate**: ~700 lines Eiffel

## Class Breakdown

| Class | Type | LOC | Description |
|-------|------|-----|-------------|
| SIMPLE_STB | Concrete | ~200 | Factory/facade |
| STB_IMAGE | Concrete | ~400 | Image instance |

## Memory Footprint

| Image Size | Channels | Memory |
|------------|----------|--------|
| 100x100 | 4 (RGBA) | ~40 KB |
| 1000x1000 | 4 (RGBA) | ~4 MB |
| 4000x3000 | 4 (RGBA) | ~48 MB |

Formula: width * height * channels bytes

## Operation Complexity

| Operation | Complexity | Notes |
|-----------|------------|-------|
| Load | O(n) | n = file size |
| Save | O(n) | n = pixel count |
| Get Pixel | O(1) | Direct access |
| Set Pixel | O(1) | Direct access |
| Fill | O(n) | n = pixel count |
| Fill Rect | O(w*h) | Rectangle area |

## Build Impact

- Compile time: Minimal (small codebase)
- Binary size: stb adds ~100KB to executable
