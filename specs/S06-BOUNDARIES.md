# S06-BOUNDARIES: simple_stb

**BACKWASH** | Date: 2026-01-23

## System Boundaries

### External Dependencies

```
+----------------+     +------------------+     +-----------+
| Application    | --> | simple_stb       | --> | stb_image |
+----------------+     +------------------+     +-----------+
                              |
                              v
                       +------------------+
                       | stb_image_write  |
                       +------------------+
```

### API Boundary

**Public API** (SIMPLE_STB):
- Image loading: load, load_rgb, load_rgba
- Image creation: create_image, create_rgb, create_rgba
- Info queries: image_info, is_valid_image

**Public API** (STB_IMAGE):
- Properties: width, height, channels
- Pixel operations: pixel, set_pixel, fill
- Writing: write_png, write_bmp, write_tga, write_jpg
- Cleanup: destroy

**Internal API**:
- C external functions (c_load_image, c_create_image, etc.)
- Pointer manipulation

### Data Type Boundaries

| Eiffel | C | Description |
|--------|---|-------------|
| STRING_GENERAL | const char* | File paths |
| INTEGER | int | Dimensions, channels |
| NATURAL_8 | unsigned char | Pixel components |
| NATURAL_32 | unsigned int | Hex colors |
| POINTER | stb_image_data* | Image handles |
| BOOLEAN | int | Success/failure |

## Responsibility Boundaries

### simple_stb Responsible For:
- Eiffel-friendly API
- Type conversions
- Error message translation
- Memory management interface

### stb_image Responsible For:
- Format decoding/encoding
- Pixel data management
- File I/O
- Compression/decompression

### Application Responsible For:
- File path validation
- Memory limits enforcement
- Calling destroy
- Error handling decisions
