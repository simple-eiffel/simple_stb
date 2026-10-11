# Changelog

All notable changes to simple_stb will be documented in this file.

## [1.1.0] - 2026-10-11

### Added
- STB_IMAGE frees its pixels when the garbage collector reclaims it (DISPOSABLE); `destroy`
  still frees them at once, and a destroyed image is not freed twice. simple_image keeps its
  images in STB_IMAGE and must not leak when a caller forgets `destroy`.
- Tests: the collector frees 200 undestroyed 512x512 images; a 1-channel image (the masks
  simple_image keeps) has stride = width and writes PNG and JPEG.

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
