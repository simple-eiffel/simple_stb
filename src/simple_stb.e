note
	description: "[
		SIMPLE_STB - Facade for stb image loading/writing library.

		Provides simplified access to stb_image and stb_image_write
		for loading, creating, manipulating, and saving images.

		Supported formats for loading:
		- PNG, JPEG, BMP, TGA, GIF, PSD, HDR, PIC, PNM

		Supported formats for writing:
		- PNG, JPEG, BMP, TGA

		Usage:
			local
				stb: SIMPLE_STB
				img: STB_IMAGE
			do
				create stb.make

				-- Load image
				img := stb.load ("photo.jpg")
				if img.is_valid then
					print ("Loaded: " + img.width.out + "x" + img.height.out + "%N")
					img.write_png ("photo.png")
					img.destroy
				end

				-- Create new image
				img := stb.create_image (200, 100, stb.Channels_rgba)
				img.fill_hex (0xFFFFFFFF)  -- White
				img.write_png ("blank.png")
				img.destroy
			end
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_STB

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize stb wrapper.
		do
			last_error := ""
		ensure
			no_error: last_error.is_empty
		end

feature -- Loading

	load (a_filename: READABLE_STRING_GENERAL): STB_IMAGE
			-- Load image from file with automatic channel detection.
		require
			filename_not_empty: not a_filename.is_empty
		do
			Result := load_channels (a_filename, 0)
		ensure
			result_exists: Result /= Void
		end

	load_rgb (a_filename: READABLE_STRING_GENERAL): STB_IMAGE
			-- Load image from file, forcing RGB (3 channels).
		require
			filename_not_empty: not a_filename.is_empty
		do
			Result := load_channels (a_filename, Channels_rgb)
		ensure
			result_exists: Result /= Void
		end

	load_rgba (a_filename: READABLE_STRING_GENERAL): STB_IMAGE
			-- Load image from file, forcing RGBA (4 channels).
		require
			filename_not_empty: not a_filename.is_empty
		do
			Result := load_channels (a_filename, Channels_rgba)
		ensure
			result_exists: Result /= Void
		end

	load_channels (a_filename: READABLE_STRING_GENERAL; a_channels: INTEGER): STB_IMAGE
			-- Load image with specified channel count (0=auto, 3=RGB, 4=RGBA).
		require
			filename_not_empty: not a_filename.is_empty
			valid_channels: a_channels >= 0 and a_channels <= 4
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_filename.to_string_8)
			create Result.make_from_pointer (c_load_image (l_filename.item, a_channels))
			if not Result.is_valid then
				last_error := Result.error_message
			else
				last_error := ""
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Creation

	create_image (a_width, a_height, a_channels: INTEGER): STB_IMAGE
			-- Create empty image with specified dimensions.
		require
			valid_width: a_width > 0
			valid_height: a_height > 0
			valid_channels: a_channels >= 1 and a_channels <= 4
		do
			create Result.make_from_pointer (c_create_image (a_width, a_height, a_channels))
			if not Result.is_valid then
				last_error := "Failed to create image"
			else
				last_error := ""
			end
		ensure
			result_exists: Result /= Void
		end

	create_rgb (a_width, a_height: INTEGER): STB_IMAGE
			-- Create empty RGB image.
		require
			valid_width: a_width > 0
			valid_height: a_height > 0
		do
			Result := create_image (a_width, a_height, Channels_rgb)
		ensure
			result_exists: Result /= Void
		end

	create_rgba (a_width, a_height: INTEGER): STB_IMAGE
			-- Create empty RGBA image.
		require
			valid_width: a_width > 0
			valid_height: a_height > 0
		do
			Result := create_image (a_width, a_height, Channels_rgba)
		ensure
			result_exists: Result /= Void
		end

feature -- Info (without loading)

	image_info (a_filename: READABLE_STRING_GENERAL): TUPLE [width, height, channels: INTEGER; valid: BOOLEAN]
			-- Get image dimensions without loading pixel data.
		require
			filename_not_empty: not a_filename.is_empty
		local
			l_filename: C_STRING
			l_width, l_height, l_channels: INTEGER
			l_ok: INTEGER
		do
			create l_filename.make (a_filename.to_string_8)
			l_ok := c_get_image_info (l_filename.item, $l_width, $l_height, $l_channels)
			Result := [l_width, l_height, l_channels, l_ok /= 0]
		end

	is_valid_image (a_filename: READABLE_STRING_GENERAL): BOOLEAN
			-- Is file a valid, loadable image?
		require
			filename_not_empty: not a_filename.is_empty
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_filename.to_string_8)
			Result := c_is_valid_image (l_filename.item) /= 0
		end

feature -- Channel Constants

	Channels_auto: INTEGER = 0
			-- Auto-detect channels.

	Channels_grey: INTEGER = 1
			-- Greyscale (1 channel).

	Channels_grey_alpha: INTEGER = 2
			-- Greyscale with alpha (2 channels).

	Channels_rgb: INTEGER = 3
			-- RGB (3 channels).

	Channels_rgba: INTEGER = 4
			-- RGBA (4 channels).

feature -- Format Info

	supported_formats: STRING
			-- Comma-separated list of supported image formats.
		do
			Result := "PNG, JPEG, BMP, TGA, GIF, PSD, HDR, PIC, PNM"
		end

	write_formats: STRING
			-- Comma-separated list of writable formats.
		do
			Result := "PNG, JPEG, BMP, TGA"
		end

feature -- Status

	last_error: STRING
			-- Last error message, empty if no error.

	has_error: BOOLEAN
			-- Did last operation fail?
		do
			Result := not last_error.is_empty
		end

feature {NONE} -- C Externals

	c_load_image (a_filename: POINTER; a_channels: INTEGER): POINTER
		external "C inline use %"simple_stb.h%""
		alias "return stb_load_image((const char*)$a_filename, $a_channels);"
		end

	c_create_image (a_width, a_height, a_channels: INTEGER): POINTER
		external "C inline use %"simple_stb.h%""
		alias "return stb_create_image($a_width, $a_height, $a_channels);"
		end

	c_get_image_info (a_filename, a_width, a_height, a_channels: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return stb_get_image_info((const char*)$a_filename, (int*)$a_width, (int*)$a_height, (int*)$a_channels);"
		end

	c_is_valid_image (a_filename: POINTER): INTEGER
		external "C inline use %"simple_stb.h%""
		alias "return stb_is_valid_image((const char*)$a_filename);"
		end

invariant
	last_error_attached: last_error /= Void

end
