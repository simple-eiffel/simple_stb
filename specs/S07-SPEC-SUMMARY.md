# S07-SPEC-SUMMARY: simple_stb

**BACKWASH** | Date: 2026-01-23

## Executive Summary

**simple_stb** provides image I/O for Eiffel applications using the stb single-header libraries:

1. **Loading**: PNG, JPEG, BMP, TGA, GIF, PSD, HDR, PIC, PNM
2. **Writing**: PNG, JPEG, BMP, TGA
3. **Creation**: Programmatic image generation
4. **Manipulation**: Pixel access, fills, flips

## Architecture Overview

```
Application
     |
     v
+------------------+
|   SIMPLE_STB     |  (Factory/Facade)
|  - load()        |
|  - create()      |
|  - image_info()  |
+------------------+
     |
     v
+------------------+
|   STB_IMAGE      |  (Image Instance)
|  - pixel ops     |
|  - fill ops      |
|  - write ops     |
|  - destroy()     |
+------------------+
     |
     v
+------------------+
| simple_stb.h     |  (C Wrapper)
+------------------+
     |
     v
+------------------+
| stb_image.h      |  (Loader)
| stb_image_write.h|  (Writer)
+------------------+
```

## Key Design Decisions

1. **Single Header**: stb simplicity preserved
2. **Two Classes**: Factory + instance pattern
3. **Manual Memory**: Explicit destroy required
4. **Hex Colors**: Convenient color specification
5. **Inline C**: No external DLLs

## Status

- **Phase**: 4 (Documentation)
- **Stability**: High
- **Test Coverage**: Good
- **Documentation**: Basic
