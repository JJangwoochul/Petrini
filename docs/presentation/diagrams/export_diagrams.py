#!/usr/bin/env python3
"""Mermaid 다이어그램을 PNG/SVG로 다운로드합니다 (mermaid.ink API 사용)."""

from __future__ import annotations

import base64
import sys
import urllib.error
import urllib.request
from pathlib import Path

DIAGRAM_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = DIAGRAM_DIR / "png"
SVG_DIR = DIAGRAM_DIR / "svg"


def to_base64_url(text: str) -> str:
    return base64.urlsafe_b64encode(text.encode("utf-8")).decode("ascii")


def download(url: str, dest: Path) -> None:
    req = urllib.request.Request(url, headers={"User-Agent": "petcare-diagram-export/1.0"})
    with urllib.request.urlopen(req, timeout=120) as resp:
        dest.write_bytes(resp.read())


def export_diagram(mmd_file: Path) -> tuple[bool, str]:
    source = mmd_file.read_text(encoding="utf-8").strip()
    encoded = to_base64_url(source)
    stem = mmd_file.stem

    png_path = OUTPUT_DIR / f"{stem}.png"
    svg_path = SVG_DIR / f"{stem}.svg"

    try:
        download(f"https://mermaid.ink/img/{encoded}", png_path)
        png_ok = True
    except (urllib.error.URLError, TimeoutError) as e:
        png_ok = False
        png_err = str(e)
    else:
        png_err = ""

    try:
        download(f"https://mermaid.ink/svg/{encoded}", svg_path)
        svg_ok = True
    except (urllib.error.URLError, TimeoutError) as e:
        svg_ok = False
        svg_err = str(e)
    else:
        svg_err = ""

    if png_ok and svg_ok:
        return True, f"OK  {stem} -> png/, svg/"
    if png_ok:
        return True, f"OK  {stem} -> png/ (svg 실패: {svg_err})"
    if svg_ok:
        return True, f"OK  {stem} -> svg/ (png 실패: {png_err})"
    return False, f"FAIL {stem}: png={png_err}, svg={svg_err}"


def main() -> int:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    SVG_DIR.mkdir(parents=True, exist_ok=True)

    mmd_files = sorted(DIAGRAM_DIR.glob("*.mmd"))
    if not mmd_files:
        print("다이어그램 .mmd 파일이 없습니다.")
        return 1

    ok_count = 0
    for mmd in mmd_files:
        ok, msg = export_diagram(mmd)
        print(msg)
        if ok:
            ok_count += 1

    print()
    print(f"완료: {ok_count}/{len(mmd_files)}")
    print(f"PNG: {OUTPUT_DIR}")
    print(f"SVG: {SVG_DIR}")
    return 0 if ok_count == len(mmd_files) else 1


if __name__ == "__main__":
    sys.exit(main())
