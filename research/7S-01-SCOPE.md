# 7S-01-SCOPE: simple_stb

**BACKWASH** | Date: 2026-01-23

## Problem Domain

Simple_stb provides image loading, creation, manipulation, and writing capabilities for Eiffel applications by wrapping the stb_image library (Sean Barrett's single-header image library).

Key capabilities:
- Load images from files (PNG, JPEG, BMP, TGA, GIF, PSD, HDR, PIC, PNM)
- Write images to files (PNG, JPEG, BMP, TGA)
- Create new images programmatically
- Pixel-level manipulation (get/set pixels)
- Fill operations (full image, rectangles)
- Image transformations (flip vertical/horizontal)
- Image info queries without full load

## Target Users

- Eiffel developers needing image processing
- Applications requiring image I/O without heavy dependencies
- GUI applications with image display needs
- Batch image processing utilities

## Business Value

- Single-header library minimizes dependencies
- Supports common image formats
- Simple API for basic image operations
- No external DLL requirements

## Out of Scope

- Advanced image processing (filters, convolution)
- Image format conversion optimization
- GPU acceleration
- Animation support (GIF frames)
- RAW camera format support
