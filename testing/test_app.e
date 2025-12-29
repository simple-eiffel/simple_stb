note
	description: "Test application for simple_stb library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run test suite.
		local
			l_tests: LIB_TESTS
		do
			print ("Running simple_stb tests...%N%N")
			create l_tests.default_create
			run_suite (l_tests)
			print ("%NAll tests completed successfully.%N")
		rescue
			print ("TEST FAILED%N")
		end

feature {NONE} -- Implementation

	run_suite (a_tests: LIB_TESTS)
			-- Run all tests from the suite.
		do
			print (" test_create_rgb_image... ")
			a_tests.test_create_rgb_image
			print ("PASS%N")

			print (" test_create_rgba_image... ")
			a_tests.test_create_rgba_image
			print ("PASS%N")

			print (" test_set_and_get_pixel... ")
			a_tests.test_set_and_get_pixel
			print ("PASS%N")

			print (" test_set_pixel_hex... ")
			a_tests.test_set_pixel_hex
			print ("PASS%N")

			print (" test_fill_image... ")
			a_tests.test_fill_image
			print ("PASS%N")

			print (" test_fill_hex... ")
			a_tests.test_fill_hex
			print ("PASS%N")

			print (" test_fill_rect... ")
			a_tests.test_fill_rect
			print ("PASS%N")

			print (" test_copy_image... ")
			a_tests.test_copy_image
			print ("PASS%N")

			print (" test_flip_vertical... ")
			a_tests.test_flip_vertical
			print ("PASS%N")

			print (" test_flip_horizontal... ")
			a_tests.test_flip_horizontal
			print ("PASS%N")

			print (" test_channel_constants... ")
			a_tests.test_channel_constants
			print ("PASS%N")

			print (" test_supported_formats... ")
			a_tests.test_supported_formats
			print ("PASS%N")

			-- Edge case tests
			print ("%NEdge Case Tests:%N")
			print (" test_minimum_image_size... ")
			a_tests.test_minimum_image_size
			print ("PASS%N")

			print (" test_large_image... ")
			a_tests.test_large_image
			print ("PASS%N")

			print (" test_pixel_at_boundaries... ")
			a_tests.test_pixel_at_boundaries
			print ("PASS%N")

			print (" test_fill_rect_at_boundaries... ")
			a_tests.test_fill_rect_at_boundaries
			print ("PASS%N")

			print (" test_color_value_boundaries... ")
			a_tests.test_color_value_boundaries
			print ("PASS%N")

			print (" test_hex_color_boundaries... ")
			a_tests.test_hex_color_boundaries
			print ("PASS%N")

			print (" test_rgb_vs_rgba_images... ")
			a_tests.test_rgb_vs_rgba_images
			print ("PASS%N")

			print (" test_copy_preserves_data... ")
			a_tests.test_copy_preserves_data
			print ("PASS%N")

			print (" test_flip_operations_reversible... ")
			a_tests.test_flip_operations_reversible
			print ("PASS%N")

			print (" test_flip_moves_pixels_correctly... ")
			a_tests.test_flip_moves_pixels_correctly
			print ("PASS%N")

			print (" test_multiple_images_independent... ")
			a_tests.test_multiple_images_independent
			print ("PASS%N")

			print (" test_rapid_create_destroy... ")
			a_tests.test_rapid_create_destroy
			print ("PASS%N")

			print (" test_fill_performance... ")
			a_tests.test_fill_performance
			print ("PASS%N")

			print (" test_empty_image_after_destroy... ")
			a_tests.test_empty_image_after_destroy
			print ("PASS%N")

			print (" test_aspect_ratios... ")
			a_tests.test_aspect_ratios
			print ("PASS%N")
		end

end
