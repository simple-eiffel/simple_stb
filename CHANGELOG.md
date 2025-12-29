# Changelog

All notable changes to simple_stb will be documented in this file.

## [1.0.0] - 2025-12-29

### Added
- Initial release
- SIMPLE_STB facade class for image loading/creation
- STB_IMAGE wrapper for pixel manipulation and writing
- Image loading: PNG, JPEG, BMP, TGA, GIF, PSD, HDR, PIC, PNM
- Image writing: PNG, JPEG (with quality), BMP, TGA
- Pixel operations: get, set, fill, fill_rect
- Hex color support (0xAARRGGBB and 0xRRGGBB)
- Image operations: copy, flip_vertical, flip_horizontal
- Format detection without loading full image
- Comprehensive test suite (11 tests)
