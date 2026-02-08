#!/usr/bin/env bash
set -euo pipefail

INPUT_PATH=${1:-src/latest.drawio}
OUTPUT_PATH=${2:-public/latest.svg}

if [[ ! -f "$INPUT_PATH" ]]; then
  echo "Input file not found: $INPUT_PATH" >&2
  exit 1
fi

if ! command -v drawio >/dev/null 2>&1; then
  echo "drawio CLI not found. Install with: npm install -g drawio" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_PATH")"

if command -v xvfb-run >/dev/null 2>&1; then
  xvfb-run -a drawio --export --format svg --output "$OUTPUT_PATH" "$INPUT_PATH"
else
  drawio --export --format svg --output "$OUTPUT_PATH" "$INPUT_PATH"
fi
