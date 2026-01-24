# 7S-03-SOLUTIONS: simple_stb


**Date**: 2026-01-23

**BACKWASH** | Date: 2026-01-23

## Alternative Solutions Considered

### 1. EiffelVision2 Image Classes
- **Pros**: Integrated with GUI library
- **Cons**: Heavy dependency, GUI-focused
- **Decision**: Too heavyweight for headless image processing

### 2. Direct libpng/libjpeg
- **Pros**: Official libraries, full feature support
- **Cons**: Multiple DLLs, complex API, separate builds
- **Decision**: Dependency management complexity

### 3. ImageMagick/GraphicsMagick
- **Pros**: Comprehensive image processing
- **Cons**: Large dependency, complex licensing
- **Decision**: Overkill for basic image I/O

### 4. stb_image (Chosen)
- **Pros**: Single header, public domain, portable, simple API
- **Cons**: Limited features, no advanced processing
- **Decision**: Perfect fit for simple image operations

## Chosen Approach

**Inline C wrapper over stb_image single-header library**

- stb_image.h for loading (PNG, JPEG, BMP, TGA, GIF, PSD, HDR, PIC, PNM)
- stb_image_write.h for writing (PNG, JPEG, BMP, TGA)
- simple_stb.h as Eiffel-friendly C wrapper
- Inline C externals for Eiffel integration

## Trade-offs Accepted

- Limited to formats stb supports
- No advanced image processing
- Basic color manipulation only
