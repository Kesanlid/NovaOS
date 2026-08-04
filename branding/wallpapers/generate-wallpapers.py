#!/usr/bin/env python3
"""
NovaOS Wallpaper Generator
Generates gradient wallpapers in various resolutions

Usage:
    python3 generate-wallpapers.py [resolution]
    
    resolution: 1920x1080, 2560x1440, 3840x2160, or all (default)
"""

import struct
import zlib
import os
import sys
from pathlib import Path

WALLPAPERS = [
    ("nova-deep-space", (10, 10, 30), (30, 40, 80)),
    ("nova-cosmic-blue", (15, 52, 96), (30, 90, 140)),
    ("nova-glow", (80, 20, 120), (233, 69, 96)),
    ("nova-gaming", (30, 15, 50), (90, 40, 120)),
    ("nova-aurora", (0, 60, 50), (0, 180, 150)),
]

RESOLUTIONS = {
    "1920x1080": (1920, 1080),
    "2560x1440": (2560, 1440),
    "3840x2160": (3840, 2160),
}


def create_png(width, height, r1, g1, b1, r2, g2, b2):
    """Create a gradient PNG"""
    
    def create_chunk(chunk_type, data):
        chunk_len = len(data)
        chunk = chunk_type + data
        crc = zlib.crc32(chunk) & 0xffffffff
        return struct.pack('>I', chunk_len) + chunk + struct.pack('>I', crc)
    
    # Create raw image data (RGB)
    raw_data = b''
    for y in range(height):
        raw_data += b'\x00'  # Filter byte
        for x in range(width):
            ratio = (x + y) / (width + height)
            r = int(r1 + (r2 - r1) * ratio)
            g = int(g1 + (g2 - g1) * ratio)
            b = int(b1 + (b2 - b1) * ratio)
            raw_data += bytes([r, g, b])
    
    # Compress data
    compressed = zlib.compress(raw_data, 1)
    
    # PNG signature
    png_data = b'\x89PNG\r\n\x1a\n'
    
    # IHDR chunk (8-bit RGB)
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    png_data += create_chunk(b'IHDR', ihdr_data)
    
    # IDAT chunk
    png_data += create_chunk(b'IDAT', compressed)
    
    # IEND chunk
    png_data += create_chunk(b'IEND', b'')
    
    return png_data


def main():
    resolution_arg = sys.argv[1] if len(sys.argv) > 1 else "all"
    
    if resolution_arg == "all":
        resolutions = RESOLUTIONS
    elif resolution_arg in RESOLUTIONS:
        resolutions = {resolution_arg: RESOLUTIONS[resolution_arg]}
    else:
        print(f"Unknown resolution: {resolution_arg}")
        print(f"Available: {', '.join(RESOLUTIONS.keys())}, all")
        return 1
    
    script_dir = Path(__file__).parent
    
    for res_name, (width, height) in resolutions.items():
        res_dir = script_dir / res_name
        res_dir.mkdir(exist_ok=True)
        
        print(f"\nGenerating {res_name} wallpapers ({width}x{height})...")
        
        for name, (r1, g1, b1), (r2, g2, b2) in WALLPAPERS:
            output_file = res_dir / f"{name}.png"
            png_data = create_png(width, height, r1, g1, b1, r2, g2, b2)
            
            with open(output_file, 'wb') as f:
                f.write(png_data)
            
            print(f"  Created {output_file.name} ({len(png_data)} bytes)")
    
    print("\nDone!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
