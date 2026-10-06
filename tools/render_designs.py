#!/usr/bin/env python3
"""Render every design in designs/ to a PNG and tile them into figures/design_library.png.

    python tools/render_designs.py
"""
import os
import subprocess

import yaml
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "figures", "designs")
CATS = ["benchware", "tools", "quick-fixes", "hardware"]
CAT_LABEL = {"benchware": "Benchware", "tools": "Tools", "quick-fixes": "Quick fixes", "hardware": "Full hardware"}
CAT_COLOR = {"benchware": "#2a78b5", "tools": "#2f9e6e", "quick-fixes": "#c77b18", "hardware": "#8a4fbf"}


def font(size, bold=False):
    for f in (f"/usr/share/fonts/truetype/dejavu/DejaVuSans{'-Bold' if bold else ''}.ttf",
              "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"):
        if os.path.exists(f):
            return ImageFont.truetype(f, size)
    return ImageFont.load_default()


def main():
    os.makedirs(OUT, exist_ok=True)
    tiles = []
    tasks = yaml.safe_load(open(os.path.join(ROOT, "bench", "tasks.yaml")))
    for t in tasks:  # task order and short titles come from the benchmark definition
        scad = os.path.join(ROOT, t["reference"])
        png = os.path.join(OUT, t["id"] + ".png")
        # preview mode (OpenCSG) gives every part the same colour scheme
        cmd = ["openscad", "-o", png, "--imgsize", "900,700", "--viewall", "--autocenter", "--colorscheme", "Tomorrow"]
        if subprocess.run(cmd + [scad], capture_output=True).returncode != 0:
            # preview needs OpenGL; on headless machines fall back to a full render (or run under xvfb-run)
            subprocess.run(cmd + ["--render", scad], check=True, capture_output=True)
        tiles.append((t["category"], t["title"], png))
        print("rendered", t["id"])
    # 4 x 4 contact sheet, one column per category
    tw, th, pad, head = 450, 350, 16, 54
    W = 4 * tw + 5 * pad
    H = head + 4 * (th + 44) + 5 * pad
    sheet = Image.new("RGB", (W, H), "white")
    d = ImageDraw.Draw(sheet)
    for ci, cat in enumerate(CATS):
        x = pad + ci * (tw + pad)
        d.rectangle([x, pad, x + tw, pad + head - 12], fill=CAT_COLOR[cat])
        d.text((x + 14, pad + 8), CAT_LABEL[cat], fill="white", font=font(26, True))
        col = [t for t in tiles if t[0] == cat]
        for ri, (_, title, png) in enumerate(col[:4]):
            y = pad + head + ri * (th + 44 + pad)
            im = Image.open(png).convert("RGB")
            im.thumbnail((tw, th))
            sheet.paste(im, (x + (tw - im.width) // 2, y))
            d.text((x + 6, y + th + 6), title[:44], fill="#222222", font=font(19))
    path = os.path.join(ROOT, "figures", "design_library.png")
    sheet.save(path, optimize=True)
    print("wrote", path)


if __name__ == "__main__":
    main()
