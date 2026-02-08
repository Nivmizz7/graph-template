#!/usr/bin/env bash
set -euo pipefail

INPUT_PATH=${1:-src/latest.drawio}
OUTPUT_PATH=${2:-public/latest.svg}

if [[ ! -f "$INPUT_PATH" ]]; then
  echo "Input file not found: $INPUT_PATH" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_PATH")"

run_drawio_npx() {
  if command -v xvfb-run >/dev/null 2>&1; then
    xvfb-run -a npx --yes @drawio/cli --export --format svg --output "$OUTPUT_PATH" "$INPUT_PATH"
  else
    npx --yes @drawio/cli --export --format svg --output "$OUTPUT_PATH" "$INPUT_PATH"
  fi
}

DRAWIO_BIN=${DRAWIO_BIN:-}
DRAWIO_ARGS=${DRAWIO_ARGS:-}
if [[ -n "$DRAWIO_BIN" ]]; then
  if [[ ! -x "$DRAWIO_BIN" ]]; then
    echo "DRAWIO_BIN is not executable: $DRAWIO_BIN" >&2
    exit 1
  fi
  if command -v xvfb-run >/dev/null 2>&1; then
    xvfb-run -a "$DRAWIO_BIN" $DRAWIO_ARGS --export --format svg --output "$OUTPUT_PATH" "$INPUT_PATH"
  else
    "$DRAWIO_BIN" $DRAWIO_ARGS --export --format svg --output "$OUTPUT_PATH" "$INPUT_PATH"
  fi
else
  if command -v npx >/dev/null 2>&1; then
    run_drawio_npx
  else
    echo "npx not found. Install Node.js or provide DRAWIO_BIN." >&2
  fi
fi

if [[ ! -f "$OUTPUT_PATH" ]]; then
  echo "Export failed: $OUTPUT_PATH not created." >&2
  exit 1
fi
