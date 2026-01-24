# S03-CONTRACTS: simple_stb

**BACKWASH** | Date: 2026-01-23

## SIMPLE_STB Contracts

### Preconditions

```eiffel
load (a_filename: READABLE_STRING_GENERAL): STB_IMAGE
    require
        filename_not_empty: not a_filename.is_empty

load_channels (a_filename: READABLE_STRING_GENERAL; a_channels: INTEGER): STB_IMAGE
    require
        filename_not_empty: not a_filename.is_empty
        valid_channels: a_channels >= 0 and a_channels <= 4

create_image (a_width, a_height, a_channels: INTEGER): STB_IMAGE
    require
        valid_width: a_width > 0
        valid_height: a_height > 0
        valid_channels: a_channels >= 1 and a_channels <= 4

image_info (a_filename: READABLE_STRING_GENERAL): TUPLE [...]
    require
        filename_not_empty: not a_filename.is_empty
```

### Postconditions

```eiffel
load: STB_IMAGE
    ensure
        result_exists: Result /= Void

make
    ensure
        no_error: last_error.is_empty
```

## STB_IMAGE Contracts

### Preconditions

```eiffel
width: INTEGER
    require
        valid: is_valid

pixel (a_x, a_y: INTEGER): TUPLE [...]
    require
        valid: is_valid
        valid_x: a_x >= 0 and a_x < width
        valid_y: a_y >= 0 and a_y < height

set_pixel (a_x, a_y: INTEGER; a_r, a_g, a_b, a_a: NATURAL_8)
    require
        valid: is_valid
        valid_x: a_x >= 0 and a_x < width
        valid_y: a_y >= 0 and a_y < height

write_png (a_filename: READABLE_STRING_GENERAL): BOOLEAN
    require
        valid: is_valid
        filename_not_empty: not a_filename.is_empty

write_jpg (a_filename: READABLE_STRING_GENERAL; a_quality: INTEGER): BOOLEAN
    require
        valid: is_valid
        filename_not_empty: not a_filename.is_empty
        valid_quality: a_quality >= 1 and a_quality <= 100
```

### Postconditions

```eiffel
width: INTEGER
    ensure
        positive: Result > 0

channels: INTEGER
    ensure
        valid_range: Result >= 1 and Result <= 4

destroy
    ensure
        destroyed: handle = default_pointer
```

## Class Invariant

```eiffel
invariant
    last_error_attached: last_error /= Void  -- SIMPLE_STB
```
