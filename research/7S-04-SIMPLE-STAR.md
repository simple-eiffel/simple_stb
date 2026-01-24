# 7S-04-SIMPLE-STAR: simple_stb

**BACKWASH** | Date: 2026-01-23

## Ecosystem Integration

### Dependencies (Incoming)
- **EiffelBase**: Core types (STRING, MANAGED_POINTER)
- **stb_image**: C header library (bundled)

### Dependents (Outgoing)
- **simple_vision**: GUI image display (potential)
- Applications needing image I/O

## Integration Patterns

### Loading Images
```eiffel
stb: SIMPLE_STB
img: STB_IMAGE

create stb.make
img := stb.load ("photo.jpg")
if img.is_valid then
    print ("Size: " + img.width.out + "x" + img.height.out)
    img.destroy
end
```

### Creating Images
```eiffel
img := stb.create_rgba (200, 100)
img.fill_hex (0xFFFFFFFF)  -- White
img.write_png ("blank.png")
img.destroy
```

### Pixel Manipulation
```eiffel
img.set_pixel (10, 10, 255, 0, 0, 255)  -- Red
color := img.pixel (10, 10)  -- [r, g, b, a]
```

## Ecosystem Fit

- Standalone image library
- Minimal dependencies
- Foundation for GUI image support
