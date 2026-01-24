# S01-PROJECT-INVENTORY: simple_stb

**BACKWASH** | Date: 2026-01-23

## Project Structure

```
simple_stb/
├── src/
│   ├── simple_stb.e            # Factory/facade class
│   ├── stb_image.e             # Image instance class
│   ├── simple_stb.h            # C wrapper header
│   ├── stb_image.h             # stb image loader
│   └── stb_image_write.h       # stb image writer
├── testing/
│   ├── test_app.e              # Test application
│   └── lib_tests.e             # Test suite
├── simple_stb.ecf              # Library ECF
├── research/                   # Research documents
└── specs/                      # Specification documents
```

## Key Files

| File | Purpose |
|------|---------|
| simple_stb.e | Image loading, creation, info queries |
| stb_image.e | Image data, manipulation, writing |
| simple_stb.h | C wrapper with Eiffel-friendly functions |

## External Headers

| Header | Version | Source |
|--------|---------|--------|
| stb_image.h | 2.28+ | github.com/nothings/stb |
| stb_image_write.h | 1.16+ | github.com/nothings/stb |

## Configuration

- **ECF**: simple_stb.ecf
- **Void Safety**: Complete
- **C Compilation**: Headers included via external include
