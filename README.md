# simple_stb

**[GitHub](https://github.com/simple-eiffel/simple_stb)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()

**Cross-platform image loading and writing library** wrapping stb_image for Eiffel applications.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Features

- **Image Loading** - PNG, JPEG, BMP, TGA, GIF, PSD, HDR, PIC, PNM
- **Image Writing** - PNG, JPEG, BMP, TGA
- **Pixel Manipulation** - Get/set pixels, fill operations
- **Image Operations** - Copy, flip vertical/horizontal
- **Format Detection** - Check image validity without loading
- **Hex Color Support** - 0xAARRGGBB and 0xRRGGBB formats

## Prerequisites

Download stb headers from [github.com/nothings/stb](https://github.com/nothings/stb) and place in `Clib/`:

```bash
cd Clib
curl -O https://raw.githubusercontent.com/nothings/stb/master/stb_image.h
curl -O https://raw.githubusercontent.com/nothings/stb/master/stb_image_write.h
```

## Installation

### Add to Your ECF

```xml
<library name="simple_stb" location="$SIMPLE_EIFFEL/simple_stb/simple_stb.ecf"/>
```

## Quick Start

```eiffel
local
    stb: SIMPLE_STB
    img: STB_IMAGE
do
    create stb.make

    -- Load an image
    img := stb.load ("photo.jpg")
    if img.is_valid then
        print ("Size: " + img.width.out + "x" + img.height.out + "%N")

        -- Manipulate
        img.fill_rect (10, 10, 50, 50, 255, 0, 0, 255)  -- Red rectangle

        -- Save in different format
        img.write_png ("photo.png")
        img.destroy
    else
        print ("Error: " + img.error_message + "%N")
    end

    -- Create new image
    img := stb.create_rgba (200, 100)
    img.fill_hex (0xFF3498DB)  -- Blue
    img.write_png ("blue.png")
    img.destroy
end
```

## Pixel Operations

```eiffel
-- Set individual pixels
img.set_pixel (x, y, r, g, b, a)
img.set_pixel_hex (x, y, 0xFFRRGGBB)

-- Get pixel color
p := img.pixel (x, y)  -- Returns TUPLE [r, g, b, a: NATURAL_8]

-- Fill operations
img.fill (r, g, b, a)
img.fill_hex (0xAARRGGBB)
img.fill_rect (x, y, width, height, r, g, b, a)
```

## Image Operations

```eiffel
-- Copy
copy := img.copy

-- Flip
img.flip_vertical
img.flip_horizontal
```

## Writing Formats

```eiffel
img.write_png ("output.png")
img.write_bmp ("output.bmp")
img.write_tga ("output.tga")
img.write_jpg ("output.jpg", 90)  -- Quality 1-100
```

## API Classes

| Class | Purpose |
|-------|---------|
| SIMPLE_STB | Facade - Image loading and creation factory |
| STB_IMAGE | Image data with pixel manipulation and writing |

## Channel Modes

| Constant | Value | Description |
|----------|-------|-------------|
| Channels_auto | 0 | Auto-detect from file |
| Channels_grey | 1 | Greyscale |
| Channels_grey_alpha | 2 | Greyscale with alpha |
| Channels_rgb | 3 | RGB (24-bit) |
| Channels_rgba | 4 | RGBA (32-bit) |

## Dependencies

- stb_image.h and stb_image_write.h (download from stb repository)
- ISE EiffelBase

## License

MIT License - See LICENSE file

stb libraries by Sean Barrett are public domain (Unlicense/MIT).

---

Part of the **Simple Eiffel** ecosystem.
