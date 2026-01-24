# S02-CLASS-CATALOG: simple_stb

**BACKWASH** | Date: 2026-01-23

## Classes

| Class | Type | Description |
|-------|------|-------------|
| SIMPLE_STB | Concrete | Factory/facade for image operations |
| STB_IMAGE | Concrete | Image data and manipulation |

## SIMPLE_STB

**Purpose**: Entry point for image loading and creation

**Creation**: `make`

**Key Features**:
- load, load_rgb, load_rgba, load_channels
- create_image, create_rgb, create_rgba
- image_info, is_valid_image
- Channel constants (Channels_auto, Channels_rgb, etc.)
- Format info (supported_formats, write_formats)
- Error reporting (last_error, has_error)

## STB_IMAGE

**Purpose**: Individual image instance with pixel data

**Creation**: `make_from_pointer` (internal use)

**Key Features**:
- Properties: width, height, channels, stride, data
- Status: is_valid, is_rgb, is_rgba, error_message
- Pixel access: pixel, set_pixel, set_pixel_hex
- Fill operations: fill, fill_hex, fill_rect, fill_rect_hex
- Operations: duplicate, flip_vertical, flip_horizontal
- Writing: write_png, write_bmp, write_tga, write_jpg
- Cleanup: destroy

## Type References

| Eiffel Type | C Type | Description |
|-------------|--------|-------------|
| POINTER | stb_image_data* | Image handle |
| NATURAL_8 | unsigned char | Pixel component |
| NATURAL_32 | unsigned int | Hex color |
