# S04-FEATURE-SPECS: simple_stb

**BACKWASH** | Date: 2026-01-23

## SIMPLE_STB Features

### Loading Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| load | (filename: STRING_GENERAL): STB_IMAGE | Load with auto channels |
| load_rgb | (filename: STRING_GENERAL): STB_IMAGE | Force RGB |
| load_rgba | (filename: STRING_GENERAL): STB_IMAGE | Force RGBA |
| load_channels | (filename: STRING_GENERAL; channels: INTEGER): STB_IMAGE | Explicit channels |

### Creation Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| create_image | (w, h, ch: INTEGER): STB_IMAGE | Create empty image |
| create_rgb | (w, h: INTEGER): STB_IMAGE | Create RGB image |
| create_rgba | (w, h: INTEGER): STB_IMAGE | Create RGBA image |

### Query Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| image_info | (filename): TUPLE [w, h, ch, valid] | Get info without loading |
| is_valid_image | (filename): BOOLEAN | Check if loadable |
| supported_formats | : STRING | Readable formats |
| write_formats | : STRING | Writable formats |

### Channel Constants

| Constant | Value | Description |
|----------|-------|-------------|
| Channels_auto | 0 | Auto-detect |
| Channels_grey | 1 | Greyscale |
| Channels_grey_alpha | 2 | Grey + alpha |
| Channels_rgb | 3 | RGB |
| Channels_rgba | 4 | RGBA |

## STB_IMAGE Features

### Access Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| width | : INTEGER | Width in pixels |
| height | : INTEGER | Height in pixels |
| channels | : INTEGER | Channel count |
| stride | : INTEGER | Bytes per row |
| data | : POINTER | Raw pixel data |
| handle | : POINTER | C handle |

### Status Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| is_valid | : BOOLEAN | Valid image data |
| is_rgb | : BOOLEAN | 3 channels |
| is_rgba | : BOOLEAN | 4 channels |
| error_message | : STRING | Error description |

### Pixel Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| pixel | (x, y): TUPLE [r, g, b, a] | Get pixel color |
| set_pixel | (x, y, r, g, b, a) | Set pixel color |
| set_pixel_hex | (x, y, color) | Set from hex |

### Fill Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| fill | (r, g, b, a) | Fill entire image |
| fill_hex | (color) | Fill from hex |
| fill_rect | (x, y, w, h, r, g, b, a) | Fill rectangle |
| fill_rect_hex | (x, y, w, h, color) | Fill rect from hex |

### Operation Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| duplicate | : STB_IMAGE | Copy image |
| flip_vertical | | Flip in place |
| flip_horizontal | | Flip in place |

### Write Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| write_png | (filename): BOOLEAN | Save as PNG |
| write_bmp | (filename): BOOLEAN | Save as BMP |
| write_tga | (filename): BOOLEAN | Save as TGA |
| write_jpg | (filename, quality): BOOLEAN | Save as JPEG |

### Cleanup

| Feature | Signature | Description |
|---------|-----------|-------------|
| destroy | | Free resources |
