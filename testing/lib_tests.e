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
			testing: "covers/{STB_IMAGE}.duplicate"
		local
			img1, img2: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img1 := stb.create_rgba (30, 30)
			img1.fill (128, 64, 32, 255)

			img2 := img1.duplicate

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

feature -- Edge Case Tests

	test_minimum_image_size
			-- Test 1x1 pixel image (minimum valid size).
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (1, 1)
			assert ("tiny image valid", img.is_valid)
			assert ("width is 1", img.width = 1)
			assert ("height is 1", img.height = 1)

			-- Set and read the single pixel
			img.set_pixel (0, 0, 255, 128, 64, 255)
			p := img.pixel (0, 0)
			assert ("pixel red correct", p.r = 255)
			assert ("pixel green correct", p.g = 128)
			assert ("pixel blue correct", p.b = 64)

			img.destroy
		end

	test_large_image
			-- Test reasonably large image (HD resolution).
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
		do
			img := stb.create_rgba (1920, 1080)
			assert ("large image valid", img.is_valid)
			assert ("large width correct", img.width = 1920)
			assert ("large height correct", img.height = 1080)

			-- Fill entire image
			img.fill (128, 128, 128, 255)

			-- Check corner pixels
			assert ("top-left pixel set", img.pixel (0, 0).r = 128)
			assert ("bottom-right pixel set", img.pixel (1919, 1079).r = 128)

			img.destroy
		end

	test_pixel_at_boundaries
			-- Test pixel access at image boundaries.
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (100, 100)
			img.fill (0, 0, 0, 255)

			-- Set corner pixels
			img.set_pixel (0, 0, 255, 0, 0, 255)           -- Top-left
			img.set_pixel (99, 0, 0, 255, 0, 255)          -- Top-right
			img.set_pixel (0, 99, 0, 0, 255, 255)          -- Bottom-left
			img.set_pixel (99, 99, 255, 255, 0, 255)       -- Bottom-right

			-- Verify corners
			p := img.pixel (0, 0)
			assert ("top-left red", p.r = 255 and p.g = 0 and p.b = 0)

			p := img.pixel (99, 0)
			assert ("top-right green", p.r = 0 and p.g = 255 and p.b = 0)

			p := img.pixel (0, 99)
			assert ("bottom-left blue", p.r = 0 and p.g = 0 and p.b = 255)

			p := img.pixel (99, 99)
			assert ("bottom-right yellow", p.r = 255 and p.g = 255 and p.b = 0)

			img.destroy
		end

	test_fill_rect_at_boundaries
			-- Test fill_rect at image edges.
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (100, 100)
			img.fill (0, 0, 0, 255)

			-- Fill rectangles at corners
			img.fill_rect (0, 0, 10, 10, 255, 0, 0, 255)            -- Top-left
			img.fill_rect (90, 0, 10, 10, 0, 255, 0, 255)           -- Top-right
			img.fill_rect (0, 90, 10, 10, 0, 0, 255, 255)           -- Bottom-left
			img.fill_rect (90, 90, 10, 10, 255, 255, 0, 255)        -- Bottom-right

			-- Verify
			p := img.pixel (5, 5)
			assert ("top-left rect", p.r = 255)

			p := img.pixel (95, 5)
			assert ("top-right rect", p.g = 255)

			p := img.pixel (5, 95)
			assert ("bottom-left rect", p.b = 255)

			p := img.pixel (95, 95)
			assert ("bottom-right rect", p.r = 255 and p.g = 255)

			img.destroy
		end

	test_fill_rect_partial_outside
			-- Test fill_rect that partially extends outside image.
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
		do
			img := stb.create_rgba (100, 100)
			img.fill (0, 0, 0, 255)

			-- These extend outside - should clip or be handled gracefully
			img.fill_rect (-10, -10, 30, 30, 255, 0, 0, 255)        -- Top-left overflow
			img.fill_rect (80, 80, 30, 30, 0, 255, 0, 255)          -- Bottom-right overflow
			img.fill_rect (-50, 40, 200, 20, 0, 0, 255, 255)        -- Horizontal overflow

			-- Should not crash - image should remain valid
			assert ("image still valid after partial overflow", img.is_valid)

			img.destroy
		end

	test_color_value_boundaries
			-- Test color values at extremes.
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)

			-- Minimum values
			img.set_pixel (0, 0, 0, 0, 0, 0)
			p := img.pixel (0, 0)
			assert ("all zeros", p.r = 0 and p.g = 0 and p.b = 0 and p.a = 0)

			-- Maximum values
			img.set_pixel (1, 1, 255, 255, 255, 255)
			p := img.pixel (1, 1)
			assert ("all max", p.r = 255 and p.g = 255 and p.b = 255 and p.a = 255)

			img.destroy
		end

	test_hex_color_boundaries
			-- Test hex color values at extremes.
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)

			-- Minimum (transparent black)
			img.set_pixel_hex (0, 0, 0x00000000)
			p := img.pixel (0, 0)
			assert ("hex min alpha", p.a = 0)
			assert ("hex min rgb", p.r = 0 and p.g = 0 and p.b = 0)

			-- Maximum (opaque white)
			img.set_pixel_hex (1, 1, 0xFFFFFFFF)
			p := img.pixel (1, 1)
			assert ("hex max alpha", p.a = 255)
			assert ("hex max rgb", p.r = 255 and p.g = 255 and p.b = 255)

			img.destroy
		end

	test_rgb_vs_rgba_images
			-- Test difference between RGB and RGBA images.
		note
			testing: "edge-case"
		local
			rgb_img, rgba_img: STB_IMAGE
		do
			rgb_img := stb.create_rgb (50, 50)
			rgba_img := stb.create_rgba (50, 50)

			assert ("rgb has 3 channels", rgb_img.channels = 3)
			assert ("rgba has 4 channels", rgba_img.channels = 4)
			assert ("rgb is_rgb", rgb_img.is_rgb)
			assert ("rgba is_rgba", rgba_img.is_rgba)

			rgb_img.destroy
			rgba_img.destroy
		end

	test_copy_preserves_data
			-- Test that duplicate creates an independent copy.
		note
			testing: "edge-case"
		local
			img1, img2: STB_IMAGE
			p1, p2: TUPLE [r, g, b, a: NATURAL_8]
		do
			img1 := stb.create_rgba (20, 20)
			img1.fill (100, 150, 200, 255)

			img2 := img1.duplicate

			-- Modify original
			img1.set_pixel (10, 10, 0, 0, 0, 255)

			-- Copy should be unchanged
			p1 := img1.pixel (10, 10)
			p2 := img2.pixel (10, 10)

			assert ("original modified", p1.r = 0)
			assert ("copy unchanged", p2.r = 100)

			img1.destroy
			img2.destroy
		end

	test_flip_operations_reversible
			-- Test that flipping twice returns to original.
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
			p_original, p_after: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)
			img.fill (0, 0, 0, 255)
			img.set_pixel (2, 3, 255, 0, 0, 255)  -- Red pixel at (2, 3)

			p_original := img.pixel (2, 3)

			-- Flip vertical twice
			img.flip_vertical
			img.flip_vertical

			p_after := img.pixel (2, 3)
			assert ("vertical flip twice restores", p_after.r = p_original.r)

			-- Flip horizontal twice
			img.flip_horizontal
			img.flip_horizontal

			p_after := img.pixel (2, 3)
			assert ("horizontal flip twice restores", p_after.r = p_original.r)

			img.destroy
		end

	test_flip_moves_pixels_correctly
			-- Test that flip moves pixels to expected locations.
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
			p: TUPLE [r, g, b, a: NATURAL_8]
		do
			img := stb.create_rgba (10, 10)
			img.fill (0, 0, 0, 255)

			-- Place unique pixel at top-left
			img.set_pixel (0, 0, 255, 0, 0, 255)

			-- Flip vertical - should move to bottom-left
			img.flip_vertical
			p := img.pixel (0, 9)
			assert ("vertical flip moves to bottom", p.r = 255)
			p := img.pixel (0, 0)
			assert ("original position cleared", p.r = 0)

			-- Reset
			img.flip_vertical

			-- Flip horizontal - should move to top-right
			img.flip_horizontal
			p := img.pixel (9, 0)
			assert ("horizontal flip moves to right", p.r = 255)

			img.destroy
		end

	test_multiple_images_independent
			-- Test creating multiple images simultaneously.
		note
			testing: "edge-case"
		local
			img1, img2, img3: STB_IMAGE
		do
			img1 := stb.create_rgba (30, 30)
			img2 := stb.create_rgba (40, 40)
			img3 := stb.create_rgba (50, 50)

			img1.fill (255, 0, 0, 255)
			img2.fill (0, 255, 0, 255)
			img3.fill (0, 0, 255, 255)

			assert ("img1 valid", img1.is_valid)
			assert ("img2 valid", img2.is_valid)
			assert ("img3 valid", img3.is_valid)

			assert ("img1 red", img1.pixel (15, 15).r = 255)
			assert ("img2 green", img2.pixel (20, 20).g = 255)
			assert ("img3 blue", img3.pixel (25, 25).b = 255)

			-- Destroy in different order
			img2.destroy
			img1.destroy
			img3.destroy
		end

	test_rapid_create_destroy
			-- Test rapid image creation and destruction.
		note
			testing: "edge-case"
			testing: "stress"
		local
			img: STB_IMAGE
			i: INTEGER
			l_val: NATURAL_8
		do
			from i := 1 until i > 100 loop
				img := stb.create_rgba (50, 50)
				l_val := (i \\ 256).to_natural_8
				img.fill (l_val, l_val, l_val, 255)
				img.destroy
				i := i + 1
			end
			-- Memory should not leak (can't directly test, but should not crash)
			assert ("rapid create/destroy succeeded", True)
		end

	test_fill_performance
			-- Test filling large image performs reasonably.
		note
			testing: "edge-case"
			testing: "performance"
		local
			img: STB_IMAGE
		do
			img := stb.create_rgba (1000, 1000)

			-- Fill should complete without timeout
			img.fill (128, 64, 32, 255)

			-- Verify it worked
			assert ("fill completed", img.pixel (500, 500).r = 128)

			img.destroy
		end

	test_empty_image_after_destroy
			-- Test that destroyed image reports invalid state.
		note
			testing: "edge-case"
		local
			img: STB_IMAGE
		do
			img := stb.create_rgba (10, 10)
			assert ("initially valid", img.is_valid)

			img.destroy
			assert ("invalid after destroy", not img.is_valid)
		end

	test_grayscale_image
			-- Test single-channel grayscale image (placeholder).
		note
			testing: "edge-case"
		do
			-- Grayscale creation not yet implemented in simple_stb
			-- This test is a placeholder for future functionality
			assert ("test completed", True)
		end

	test_aspect_ratios
			-- Test various image aspect ratios.
		note
			testing: "edge-case"
		local
			wide, tall, square: STB_IMAGE
		do
			wide := stb.create_rgba (200, 50)     -- 4:1 wide
			tall := stb.create_rgba (50, 200)     -- 1:4 tall
			square := stb.create_rgba (100, 100)  -- 1:1 square

			assert ("wide valid", wide.is_valid and wide.width = 200 and wide.height = 50)
			assert ("tall valid", tall.is_valid and tall.width = 50 and tall.height = 200)
			assert ("square valid", square.is_valid and square.width = 100 and square.height = 100)

			-- Test operations on unusual aspect ratios
			wide.fill (255, 0, 0, 255)
			tall.fill (0, 255, 0, 255)

			wide.flip_horizontal
			tall.flip_vertical

			assert ("wide still valid after flip", wide.is_valid)
			assert ("tall still valid after flip", tall.is_valid)

			wide.destroy
			tall.destroy
			square.destroy
		end

end
