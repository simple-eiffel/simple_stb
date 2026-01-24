# S05-CONSTRAINTS: simple_stb

**BACKWASH** | Date: 2026-01-23

## Technical Constraints

### Image Format Constraints
- **Read Formats**: PNG, JPEG, BMP, TGA, GIF (first frame), PSD, HDR, PIC, PNM
- **Write Formats**: PNG, JPEG, BMP, TGA
- **No Animation**: GIF loads first frame only
- **No RAW**: Camera RAW not supported

### Size Constraints
- **Max Dimensions**: Limited by available memory
- **Practical Limit**: ~16K x 16K pixels (1GB+ memory)
- **Channel Limit**: 1-4 channels

### Memory Constraints
- **Uncompressed**: Images stored uncompressed in memory
- **Memory Formula**: width * height * channels bytes
- **No Streaming**: Full image loaded at once

### Platform Constraints
- **Windows Primary**: Tested on Windows
- **Little Endian**: Assumes little-endian architecture
- **32/64-bit**: Works on both

## Design Constraints

### API Constraints
- **Explicit Destroy**: Must call destroy to free memory
- **No Reference Counting**: Manual memory management
- **Thread Safety**: Not thread-safe

### Coordinate System
- **Origin**: (0, 0) = top-left corner
- **X Axis**: Left to right
- **Y Axis**: Top to bottom

### Color Format
- **Byte Order**: RGBA (one byte per component)
- **Value Range**: 0-255 per component
- **Hex Format**: 0xAARRGGBB
