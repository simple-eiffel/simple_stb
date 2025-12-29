/*
 * simple_stb.h - Cross-platform image loading/writing wrapper for Eiffel
 *
 * Wraps stb_image and stb_image_write libraries by Sean Barrett.
 * stb libraries are public domain (unlicense/MIT).
 *
 * SETUP REQUIRED:
 * Download stb headers from https://github.com/nothings/stb and place in this folder:
 *   - stb_image.h
 *   - stb_image_write.h
 *
 * Copyright (c) 2025 Larry Rix - MIT License
 */

#ifndef SIMPLE_STB_H
#define SIMPLE_STB_H

/* Implementation defines - only in ONE compilation unit */
#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION

/* stb configuration */
#define STBI_NO_STDIO  /* We'll handle file I/O ourselves for better error handling */
#undef STBI_NO_STDIO   /* Actually, enable stdio for simplicity */

#include "stb_image.h"
#include "stb_image_write.h"

#include <stdlib.h>
#include <string.h>

/* ============ IMAGE DATA STRUCTURE ============ */

typedef struct {
    unsigned char* data;    /* Pixel data (RGBA or RGB) */
    int width;              /* Image width */
    int height;             /* Image height */
    int channels;           /* Number of channels (3=RGB, 4=RGBA) */
    int stride;             /* Bytes per row */
    char* error;            /* Error message if any */
} stb_image_data;

/* ============ IMAGE LOADING ============ */

/* Load image from file. Returns allocated stb_image_data.
 * Caller must call stb_free_image() when done.
 * desired_channels: 0=auto, 3=RGB, 4=RGBA
 */
static stb_image_data* stb_load_image(const char* filename, int desired_channels) {
    stb_image_data* img = (stb_image_data*)malloc(sizeof(stb_image_data));
    if (!img) return NULL;

    memset(img, 0, sizeof(stb_image_data));

    img->data = stbi_load(filename, &img->width, &img->height, &img->channels, desired_channels);

    if (img->data == NULL) {
        const char* err = stbi_failure_reason();
        if (err) {
            img->error = (char*)malloc(strlen(err) + 1);
            if (img->error) strcpy(img->error, err);
        }
        return img;
    }

    /* Update channels if we forced a specific number */
    if (desired_channels > 0) {
        img->channels = desired_channels;
    }

    img->stride = img->width * img->channels;
    return img;
}

/* Load image from memory buffer */
static stb_image_data* stb_load_image_from_memory(const unsigned char* buffer, int len, int desired_channels) {
    stb_image_data* img = (stb_image_data*)malloc(sizeof(stb_image_data));
    if (!img) return NULL;

    memset(img, 0, sizeof(stb_image_data));

    img->data = stbi_load_from_memory(buffer, len, &img->width, &img->height, &img->channels, desired_channels);

    if (img->data == NULL) {
        const char* err = stbi_failure_reason();
        if (err) {
            img->error = (char*)malloc(strlen(err) + 1);
            if (img->error) strcpy(img->error, err);
        }
        return img;
    }

    if (desired_channels > 0) {
        img->channels = desired_channels;
    }

    img->stride = img->width * img->channels;
    return img;
}

/* Create empty image with specified dimensions */
static stb_image_data* stb_create_image(int width, int height, int channels) {
    stb_image_data* img;
    size_t size;

    if (width <= 0 || height <= 0 || channels < 1 || channels > 4) {
        return NULL;
    }

    img = (stb_image_data*)malloc(sizeof(stb_image_data));
    if (!img) return NULL;

    memset(img, 0, sizeof(stb_image_data));

    size = (size_t)width * height * channels;
    img->data = (unsigned char*)malloc(size);
    if (!img->data) {
        free(img);
        return NULL;
    }

    memset(img->data, 0, size);
    img->width = width;
    img->height = height;
    img->channels = channels;
    img->stride = width * channels;
    return img;
}

/* Free image data */
static void stb_free_image(stb_image_data* img) {
    if (img) {
        if (img->data) stbi_image_free(img->data);
        if (img->error) free(img->error);
        free(img);
    }
}

/* ============ IMAGE INFO (without loading full data) ============ */

/* Get image dimensions without loading pixel data.
 * Returns 1 on success, 0 on failure.
 */
static int stb_get_image_info(const char* filename, int* width, int* height, int* channels) {
    return stbi_info(filename, width, height, channels);
}

/* ============ IMAGE WRITING ============ */

/* Write image to PNG file. Returns 1 on success. */
static int stb_write_png(const char* filename, stb_image_data* img) {
    if (!img || !img->data || !filename) return 0;
    return stbi_write_png(filename, img->width, img->height, img->channels, img->data, img->stride);
}

/* Write image to BMP file. Returns 1 on success. */
static int stb_write_bmp(const char* filename, stb_image_data* img) {
    if (!img || !img->data || !filename) return 0;
    return stbi_write_bmp(filename, img->width, img->height, img->channels, img->data);
}

/* Write image to TGA file. Returns 1 on success. */
static int stb_write_tga(const char* filename, stb_image_data* img) {
    if (!img || !img->data || !filename) return 0;
    return stbi_write_tga(filename, img->width, img->height, img->channels, img->data);
}

/* Write image to JPG file with quality (1-100). Returns 1 on success. */
static int stb_write_jpg(const char* filename, stb_image_data* img, int quality) {
    if (!img || !img->data || !filename) return 0;
    if (quality < 1) quality = 1;
    if (quality > 100) quality = 100;
    return stbi_write_jpg(filename, img->width, img->height, img->channels, img->data, quality);
}

/* Write raw pixel data to PNG */
static int stb_write_png_raw(const char* filename, int width, int height, int channels,
                              const unsigned char* data, int stride) {
    if (!data || !filename || width <= 0 || height <= 0) return 0;
    return stbi_write_png(filename, width, height, channels, data, stride);
}

/* ============ PIXEL ACCESS ============ */

/* Get pixel at (x, y). Returns pointer to pixel data (RGB or RGBA). */
static unsigned char* stb_get_pixel(stb_image_data* img, int x, int y) {
    if (!img || !img->data) return NULL;
    if (x < 0 || x >= img->width || y < 0 || y >= img->height) return NULL;
    return img->data + (y * img->stride) + (x * img->channels);
}

/* Set pixel at (x, y) from RGBA values */
static void stb_set_pixel(stb_image_data* img, int x, int y, unsigned char r, unsigned char g, unsigned char b, unsigned char a) {
    unsigned char* p;
    if (!img || !img->data) return;
    if (x < 0 || x >= img->width || y < 0 || y >= img->height) return;

    p = img->data + (y * img->stride) + (x * img->channels);
    p[0] = r;
    if (img->channels > 1) p[1] = g;
    if (img->channels > 2) p[2] = b;
    if (img->channels > 3) p[3] = a;
}

/* Fill entire image with color */
static void stb_fill(stb_image_data* img, unsigned char r, unsigned char g, unsigned char b, unsigned char a) {
    int x, y;
    if (!img || !img->data) return;

    for (y = 0; y < img->height; y++) {
        for (x = 0; x < img->width; x++) {
            stb_set_pixel(img, x, y, r, g, b, a);
        }
    }
}

/* Fill rectangle with color */
static void stb_fill_rect(stb_image_data* img, int x, int y, int w, int h,
                          unsigned char r, unsigned char g, unsigned char b, unsigned char a) {
    int px, py;
    int x2, y2;

    if (!img || !img->data) return;

    x2 = x + w;
    y2 = y + h;
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x2 > img->width) x2 = img->width;
    if (y2 > img->height) y2 = img->height;

    for (py = y; py < y2; py++) {
        for (px = x; px < x2; px++) {
            stb_set_pixel(img, px, py, r, g, b, a);
        }
    }
}

/* ============ IMAGE OPERATIONS ============ */

/* Copy image data */
static stb_image_data* stb_copy_image(stb_image_data* src) {
    stb_image_data* dst;
    size_t size;

    if (!src || !src->data) return NULL;

    dst = stb_create_image(src->width, src->height, src->channels);
    if (!dst) return NULL;

    size = (size_t)src->width * src->height * src->channels;
    memcpy(dst->data, src->data, size);
    return dst;
}

/* Flip image vertically (in place) */
static void stb_flip_vertical(stb_image_data* img) {
    int y;
    unsigned char* temp;
    unsigned char* top;
    unsigned char* bottom;

    if (!img || !img->data) return;

    temp = (unsigned char*)malloc(img->stride);
    if (!temp) return;

    for (y = 0; y < img->height / 2; y++) {
        top = img->data + (y * img->stride);
        bottom = img->data + ((img->height - 1 - y) * img->stride);
        memcpy(temp, top, img->stride);
        memcpy(top, bottom, img->stride);
        memcpy(bottom, temp, img->stride);
    }

    free(temp);
}

/* Flip image horizontally (in place) */
static void stb_flip_horizontal(stb_image_data* img) {
    int x, y;
    unsigned char* row;
    unsigned char temp[4];  /* Max 4 channels */

    if (!img || !img->data) return;

    for (y = 0; y < img->height; y++) {
        row = img->data + (y * img->stride);
        for (x = 0; x < img->width / 2; x++) {
            int x2 = img->width - 1 - x;
            unsigned char* p1 = row + (x * img->channels);
            unsigned char* p2 = row + (x2 * img->channels);

            memcpy(temp, p1, img->channels);
            memcpy(p1, p2, img->channels);
            memcpy(p2, temp, img->channels);
        }
    }
}

/* ============ FORMAT DETECTION ============ */

/* Check if file is a valid image format */
static int stb_is_valid_image(const char* filename) {
    int w, h, c;
    return stbi_info(filename, &w, &h, &c);
}

/* Get supported formats string */
static const char* stb_supported_formats(void) {
    return "PNG, JPEG, BMP, TGA, GIF, PSD, HDR, PIC, PNM";
}

#endif /* SIMPLE_STB_H */
