# 7S-02-STANDARDS: simple_stb


**Date**: 2026-01-23

**BACKWASH** | Date: 2026-01-23

## Language Standards

- **Eiffel**: ECMA-367 compliant
- **C**: C99 for stb_image integration
- **Image Formats**: Industry standard PNG, JPEG, BMP, TGA

## Platform Standards

- **Target OS**: Windows (primary)
- **Architecture**: x64, x86
- **stb Version**: stb_image.h and stb_image_write.h (public domain)

## Simple Eiffel Ecosystem Standards

- Design by Contract (DBC) on all public features
- Void safety enabled
- Inline C pattern for native calls
- ECF-based project configuration

## API Conventions

- SIMPLE_STB: Factory/facade for image operations
- STB_IMAGE: Individual image instance
- Consistent coordinate system: (0,0) = top-left
- Color order: RGBA

## Memory Management

- Images must be explicitly destroyed with `destroy`
- C-allocated memory freed through externals
- Eiffel manages wrapper objects

## Error Handling

- Operations return status or set last_error
- Invalid images have is_valid = False
- Error messages accessible via error_message
