note
	description: "Test suite for simple_stb library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	LIB_TESTS

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Setup

	on_prepare
			-- Setup before tests.
		do
			create stb.make
		end

feature -- Access

	stb: SIMPLE_STB
			-- STB facade for testing.

feature -- Creation Tests

	test_create_rgb_image
			-- Test creating an RGB image.
		note
			testing: "covers/{SIMPLE_STB}.create_rgb"
		local
			img: STB_IMAGE
		do
			img := stb.create_rgb (100, 50)
			assert ("image created", img /= Void)
			assert ("image valid", img.is_valid)
			assert ("width correct", img.width = 100)
			assert ("height correct", img.height = 50)
			assert ("channels correct", img.channels = 3)
			assert ("is rgb", img.is_rgb)
			img.destroy
			assert ("destroyed", not img.is_valid)
		end

	test_create_rgba_image
			-- Test creating an RGBA image.
		note
			testing: "covers/{SIMPLE_STB}.create_rgba"
		local
			img: STB_IMAGE
		do
			img := stb.create_rgba (80, 60)
			assert ("image created", img /= Void)
			assert ("image valid", img.is_valid)
			assert ("width correct", img.width = 80)
			assert ("height correct", img.height = 60)
			assert ("channels correct", img.channels = 4)
			assert ("is rgba", img.is_rgba)
			img.destroy
		end

feature -- Pixel Tests

	test_set_and_get_pixel
			-- Test setting and getting pixel values.
		note
			testing: "covers/{STB_IMAGE}.set_pixel"
			testing: "covers/{STB_IMAGE}.pixel"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)

			-- Set a red pixel
			img.set_pixel (5, 5, 255, 0, 0, 255)

			-- Read it back
			p := img.pixel (5, 5)
			assert ("red correct", p.r = 255)
			assert ("green correct", p.g = 0)
			assert ("blue correct", p.b = 0)
			assert ("alpha correct", p.a = 255)

			img.destroy
		end

	test_set_pixel_hex
			-- Test setting pixel from hex value.
		note
			testing: "covers/{STB_IMAGE}.set_pixel_hex"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)

			-- Set pixel using hex (0xAARRGGBB format)
			img.set_pixel_hex (3, 3, 0xFF3498DB)  -- Blue with full alpha

			p := img.pixel (3, 3)
			assert ("red correct", p.r = 0x34)
			assert ("green correct", p.g = 0x98)
			assert ("blue correct", p.b = 0xDB)
			assert ("alpha correct", p.a = 0xFF)

			img.destroy
		end

feature -- Fill Tests

	test_fill_image
			-- Test filling entire image.
		note
			testing: "covers/{STB_IMAGE}.fill"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (20, 20)
			img.fill (0, 255, 0, 255)  -- Green

			-- Check multiple pixels
			p := img.pixel (0, 0)
			assert ("corner green", p.g = 255 and p.r = 0)

			p := img.pixel (19, 19)
			assert ("opposite corner green", p.g = 255 and p.r = 0)

			p := img.pixel (10, 10)
			assert ("center green", p.g = 255 and p.r = 0)

			img.destroy
		end

	test_fill_hex
			-- Test filling with hex color.
		note
			testing: "covers/{STB_IMAGE}.fill_hex"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)
			img.fill_hex (0xFFE74C3C)  -- Red

			p := img.pixel (5, 5)
			assert ("red component", p.r = 0xE7)
			assert ("green component", p.g = 0x4C)
			assert ("blue component", p.b = 0x3C)

			img.destroy
		end

	test_fill_rect
			-- Test filling a rectangle.
		note
			testing: "covers/{STB_IMAGE}.fill_rect"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (50, 50)
			img.fill (0, 0, 0, 255)  -- Black background
			img.fill_rect (10, 10, 20, 20, 255, 255, 255, 255)  -- White rectangle

			-- Check outside rectangle (should be black)
			p := img.pixel (5, 5)
			assert ("outside is black", p.r = 0 and p.g = 0 and p.b = 0)

			-- Check inside rectangle (should be white)
			p := img.pixel (15, 15)
			assert ("inside is white", p.r = 255 and p.g = 255 and p.b = 255)

			img.destroy
		end

feature -- Operation Tests

	test_copy_image
			-- Test copying an image.
		note
			testing: "covers/{STB_IMAGE}.copy"
		local
			img1, img2: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img1 := stb.create_rgba (30, 30)
			img1.fill (128, 64, 32, 255)

			img2 := img1.copy

			assert ("copy valid", img2.is_valid)
			assert ("same width", img2.width = img1.width)
			assert ("same height", img2.height = img1.height)

			p := img2.pixel (15, 15)
			assert ("copied red", p.r = 128)
			assert ("copied green", p.g = 64)
			assert ("copied blue", p.b = 32)

			img1.destroy
			img2.destroy
		end

	test_flip_vertical
			-- Test vertical flip.
		note
			testing: "covers/{STB_IMAGE}.flip_vertical"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)
			img.fill (0, 0, 0, 255)  -- Black
			img.set_pixel (5, 0, 255, 0, 0, 255)  -- Red at top

			img.flip_vertical

			-- Red should now be at bottom
			p := img.pixel (5, 9)
			assert ("red moved to bottom", p.r = 255)

			p := img.pixel (5, 0)
			assert ("top is now black", p.r = 0)

			img.destroy
		end

	test_flip_horizontal
			-- Test horizontal flip.
		note
			testing: "covers/{STB_IMAGE}.flip_horizontal"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)
			img.fill (0, 0, 0, 255)  -- Black
			img.set_pixel (0, 5, 0, 255, 0, 255)  -- Green at left

			img.flip_horizontal

			-- Green should now be at right
			p := img.pixel (9, 5)
			assert ("green moved to right", p.g = 255)

			p := img.pixel (0, 5)
			assert ("left is now black", p.g = 0)

			img.destroy
		end

feature -- Channel Constant Tests

	test_channel_constants
			-- Test channel constant values.
		note
			testing: "covers/{SIMPLE_STB}"
		do
			assert ("auto is 0", stb.Channels_auto = 0)
			assert ("grey is 1", stb.Channels_grey = 1)
			assert ("grey_alpha is 2", stb.Channels_grey_alpha = 2)
			assert ("rgb is 3", stb.Channels_rgb = 3)
			assert ("rgba is 4", stb.Channels_rgba = 4)
		end

feature -- Format Tests

	test_supported_formats
			-- Test format strings.
		note
			testing: "covers/{SIMPLE_STB}.supported_formats"
		do
			assert ("has PNG", stb.supported_formats.has_substring ("PNG"))
			assert ("has JPEG", stb.supported_formats.has_substring ("JPEG"))
			assert ("has BMP", stb.supported_formats.has_substring ("BMP"))
		end

end
