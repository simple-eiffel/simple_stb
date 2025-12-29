note
	description: "[
		STB_IMAGE - Image data wrapper for stb library.

		Represents loaded or created image data with pixel manipulation
		and file writing capabilities.

		Usage:
			local
				img: STB_IMAGE
			do
				-- After loading via SIMPLE_STB...
				if img.is_valid then
					-- Access properties
					print ("Size: " + img.width.out + "x" + img.height.out + "%N")
					print ("Channels: " + img.channels.out + "%N")

					-- Manipulate pixels
					img.set_pixel (10, 10, 255, 0, 0, 255)  -- Red pixel
					img.fill_rect (20, 20, 50, 50, 0, 255, 0, 255)  -- Green rect

					-- Save
					img.write_png ("output.png")

					-- Always destroy when done
					img.destroy
				end
			end
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	STB_IMAGE

create
	make_from_pointer

feature {NONE} -- Initialization

	make_from_pointer (a_handle: POINTER)
			-- Create from C stb_image_data pointer.
		do
			handle := a_handle
		end

feature -- Access

	handle: POINTER
			-- Underlying stb_image_data pointer.

	width: INTEGER
			-- Image width in pixels.
		require
			valid: is_valid
		do
			Result := c_get_width (handle)
		ensure
			positive: Result > 0
		end

	height: INTEGER
			-- Image height in pixels.
		require
			valid: is_valid
		do
			Result := c_get_height (handle)
		ensure
			positive: Result > 0
		end

	channels: INTEGER
			-- Number of color channels (1-4).
		require
			valid: is_valid
		do
			Result := c_get_channels (handle)
		ensure
			valid_range: Result >= 1 and Result <= 4
		end

	stride: INTEGER
			-- Bytes per row.
		require
			valid: is_valid
		do
			Result := c_get_stride (handle)
		end

	data: POINTER
			-- Raw pixel data pointer.
		require
			valid: is_valid
		do
			Result := c_get_data (handle)
		end

	is_rgb: BOOLEAN
			-- Is this an RGB image (3 channels)?
		do
			Result := is_valid and then channels = 3
		end

	is_rgba: BOOLEAN
			-- Is this an RGBA image (4 channels)?
		do
			Result := is_valid and then channels = 4
		end

feature -- Status

	is_valid: BOOLEAN
			-- Is image data valid?
		do
			Result := handle /= default_pointer and then c_get_data (handle) /= default_pointer
		end

	error_message: STRING
			-- Error message if loading failed.
		local
			l_ptr: POINTER
			l_c_string: C_STRING
		do
			if handle /= default_pointer then
				l_ptr := c_get_error (handle)
				if l_ptr /= default_pointer then
					create l_c_string.make_by_pointer (l_ptr)
					Result := l_c_string.string
				else
					Result := ""
				end
			else
				Result := "Null image handle"
			end
		end

feature -- Pixel Access

	pixel (a_x, a_y: INTEGER): TUPLE [r, g, b, a: NATURAL_8]
			-- Get pixel color at (x, y).
		require
			valid: is_valid
			valid_x: a_x >= 0 and a_x < width
			valid_y: a_y >= 0 and a_y < height
		local
			l_ptr: POINTER
			l_managed: MANAGED_POINTER
			l_r, l_g, l_b, l_a: NATURAL_8
		do
			l_r := 0
			l_g := 0
			l_b := 0
			l_a := 255
			l_ptr := c_get_pixel (handle, a_x, a_y)
			if l_ptr /= default_pointer and then channels >= 1 then
				create l_managed.share_from_pointer (l_ptr, channels)
				l_r := l_managed.read_natural_8 (0)
				if channels >= 2 then
					l_g := l_managed.read_natural_8 (1)
				end
				if channels >= 3 then
					l_b := l_managed.read_natural_8 (2)
				end
				if channels >= 4 then
					l_a := l_managed.read_natural_8 (3)
				end
			end
			Result := [l_r, l_g, l_b, l_a]
		end

	set_pixel (a_x, a_y: INTEGER; a_r, a_g, a_b, a_a: NATURAL_8)
			-- Set pixel color at (x, y).
		require
			valid: is_valid
			valid_x: a_x >= 0 and a_x < width
			valid_y: a_y >= 0 and a_y < height
		do
			c_set_pixel (handle, a_x, a_y, a_r, a_g, a_b, a_a)
		end

	set_pixel_hex (a_x, a_y: INTEGER; a_color: NATURAL_32)
			-- Set pixel from hex color (0xAARRGGBB or 0xRRGGBB).
		require
			valid: is_valid
			valid_x: a_x >= 0 and a_x < width
			valid_y: a_y >= 0 and a_y < height
		local
			l_r, l_g, l_b, l_a: NATURAL_8
		do
			l_a := ((a_color |>> 24) & 0xFF).to_natural_8
			l_r := ((a_color |>> 16) & 0xFF).to_natural_8
			l_g := ((a_color |>> 8) & 0xFF).to_natural_8
			l_b := (a_color & 0xFF).to_natural_8
			if l_a = 0 and a_color < 0x01000000 then
				l_a := 255  -- No alpha specified, default to opaque
			end
			c_set_pixel (handle, a_x, a_y, l_r, l_g, l_b, l_a)
		end

feature -- Fill Operations

	fill (a_r, a_g, a_b, a_a: NATURAL_8)
			-- Fill entire image with color.
		require
			valid: is_valid
		do
			c_fill (handle, a_r, a_g, a_b, a_a)
		end

	fill_hex (a_color: NATURAL_32)
			-- Fill entire image with hex color.
		require
			valid: is_valid
		local
			l_r, l_g, l_b, l_a: NATURAL_8
		do
			l_a := ((a_color |>> 24) & 0xFF).to_natural_8
			l_r := ((a_color |>> 16) & 0xFF).to_natural_8
			l_g := ((a_color |>> 8) & 0xFF).to_natural_8
			l_b := (a_color & 0xFF).to_natural_8
			if l_a = 0 and a_color < 0x01000000 then
				l_a := 255
			end
			c_fill (handle, l_r, l_g, l_b, l_a)
		end

	fill_rect (a_x, a_y, a_w, a_h: INTEGER; a_r, a_g, a_b, a_a: NATURAL_8)
			-- Fill rectangle with color.
		require
			valid: is_valid
		do
			c_fill_rect (handle, a_x, a_y, a_w, a_h, a_r, a_g, a_b, a_a)
		end

	fill_rect_hex (a_x, a_y, a_w, a_h: INTEGER; a_color: NATURAL_32)
			-- Fill rectangle with hex color.
		require
			valid: is_valid
		local
			l_r, l_g, l_b, l_a: NATURAL_8
		do
			l_a := ((a_color |>> 24) & 0xFF).to_natural_8
			l_r := ((a_color |>> 16) & 0xFF).to_natural_8
			l_g := ((a_color |>> 8) & 0xFF).to_natural_8
			l_b := (a_color & 0xFF).to_natural_8
			if l_a = 0 and a_color < 0x01000000 then
				l_a := 255
			end
			c_fill_rect (handle, a_x, a_y, a_w, a_h, l_r, l_g, l_b, l_a)
		end

feature -- Operations

	duplicate: STB_IMAGE
			-- Create a duplicate of this image.
		require
			valid: is_valid
		do
			create Result.make_from_pointer (c_copy_image (handle))
		ensure
			result_exists: Result /= Void
		end

	flip_vertical
			-- Flip image vertically (in place).
		require
			valid: is_valid
		do
			c_flip_vertical (handle)
		end

	flip_horizontal
			-- Flip image horizontally (in place).
		require
			valid: is_valid
		do
			c_flip_horizontal (handle)
		end

feature -- Writing

	write_png (a_filename: READABLE_STRING_GENERAL): BOOLEAN
			-- Write image to PNG file.
		require
			valid: is_valid
			filename_not_empty: not a_filename.is_empty
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_filename.to_string_8)
			Result := c_write_png (l_filename.item, handle) /= 0
		end

	write_bmp (a_filename: READABLE_STRING_GENERAL): BOOLEAN
			-- Write image to BMP file.
		require
			valid: is_valid
			filename_not_empty: not a_filename.is_empty
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_filename.to_string_8)
			Result := c_write_bmp (l_filename.item, handle) /= 0
		end

	write_tga (a_filename: READABLE_STRING_GENERAL): BOOLEAN
			-- Write image to TGA file.
		require
			valid: is_valid
			filename_not_empty: not a_filename.is_empty
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_filename.to_string_8)
			Result := c_write_tga (l_filename.item, handle) /= 0
		end

	write_jpg (a_filename: READABLE_STRING_GENERAL; a_quality: INTEGER): BOOLEAN
			-- Write image to JPG file with quality (1-100).
		require
			valid: is_valid
			filename_not_empty: not a_filename.is_empty
			valid_quality: a_quality >= 1 and a_quality <= 100
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_filename.to_string_8)
			Result := c_write_jpg (l_filename.item, handle, a_quality) /= 0
		end

feature -- Disposal

	destroy
			-- Release image resources.
		do
			if handle /= default_pointer then
				c_free_image (handle)
				handle := default_pointer
			end
		ensure
			destroyed: handle = default_pointer
		end

feature {NONE} -- C Externals

	c_get_width (a_img: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return ((stb_image_data*)$a_img)->width;"
		end

	c_get_height (a_img: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return ((stb_image_data*)$a_img)->height;"
		end

	c_get_channels (a_img: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return ((stb_image_data*)$a_img)->channels;"
		end

	c_get_stride (a_img: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return ((stb_image_data*)$a_img)->stride;"
		end

	c_get_data (a_img: POINTER): POINTER
		external "C inline use %"simple_stb.h%""
		alias "return ((stb_image_data*)$a_img)->data;"
		end

	c_get_error (a_img: POINTER): POINTER
		external "C inline use %"simple_stb.h%""
		alias "return ((stb_image_data*)$a_img)->error;"
		end

	c_get_pixel (a_img: POINTER; a_x, a_y: INTEGER): POINTER
		external "C inline use %"simple_stb.h%""
		alias "return stb_get_pixel((stb_image_data*)$a_img, $a_x, $a_y);"
		end

	c_set_pixel (a_img: POINTER; a_x, a_y: INTEGER; a_r, a_g, a_b, a_a: NATURAL_8)
		external "C inline use %"simple_stb.h%""
		alias "stb_set_pixel((stb_image_data*)$a_img, $a_x, $a_y, $a_r, $a_g, $a_b, $a_a);"
		end

	c_fill (a_img: POINTER; a_r, a_g, a_b, a_a: NATURAL_8)
		external "C inline use %"simple_stb.h%""
		alias "stb_fill((stb_image_data*)$a_img, $a_r, $a_g, $a_b, $a_a);"
		end

	c_fill_rect (a_img: POINTER; a_x, a_y, a_w, a_h: INTEGER; a_r, a_g, a_b, a_a: NATURAL_8)
		external "C inline use %"simple_stb.h%""
		alias "stb_fill_rect((stb_image_data*)$a_img, $a_x, $a_y, $a_w, $a_h, $a_r, $a_g, $a_b, $a_a);"
		end

	c_copy_image (a_img: POINTER): POINTER
		external "C inline use %"simple_stb.h%""
		alias "return stb_copy_image((stb_image_data*)$a_img);"
		end

	c_flip_vertical (a_img: POINTER)
		external "C inline use %"simple_stb.h%""
		alias "stb_flip_vertical((stb_image_data*)$a_img);"
		end

	c_flip_horizontal (a_img: POINTER)
		external "C inline use %"simple_stb.h%""
		alias "stb_flip_horizontal((stb_image_data*)$a_img);"
		end

	c_write_png (a_filename, a_img: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return stb_write_png((const char*)$a_filename, (stb_image_data*)$a_img);"
		end

	c_write_bmp (a_filename, a_img: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return stb_write_bmp((const char*)$a_filename, (stb_image_data*)$a_img);"
		end

	c_write_tga (a_filename, a_img: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return stb_write_tga((const char*)$a_filename, (stb_image_data*)$a_img);"
		end

	c_write_jpg (a_filename, a_img: POINTER; a_quality: INTEGER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return stb_write_jpg((const char*)$a_filename, (stb_image_data*)$a_img, $a_quality);"
		end

	c_free_image (a_img: POINTER)
		external "C inline use %"simple_stb.h%""
		alias "stb_free_image((stb_image_data*)$a_img);"
		end

end
