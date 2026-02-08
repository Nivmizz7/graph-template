#!/usr/bin/env bash
set -euo pipefail

INPUT_PATH=${1:-src/latest.drawio}
OUTPUT_PATH=${2:-public/latest.svg}

if [[ ! -f "$INPUT_PATH" ]]; then
  echo "Input file not found: $INPUT_PATH" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_PATH")"

run_drawio() {
  if command -v xvfb-run >/dev/null 2>&1; then
    xvfb-run -a drawio --export --format svg --output "$OUTPUT_PATH" "$INPUT_PATH"
  else
    drawio --export --format svg --output "$OUTPUT_PATH" "$INPUT_PATH"
  fi
}

run_docker() {
  local root input_abs output_abs input_in_container output_in_container
  root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
  input_abs=$(realpath "$INPUT_PATH")
  output_abs=$(realpath -m "$OUTPUT_PATH")

  if [[ "$input_abs" != "$root"/* || "$output_abs" != "$root"/* ]]; then
    echo "Input/output must be inside repo: $root" >&2
    return 1
  fi

  input_in_container="/data/${input_abs#$root/}"
  output_in_container="/data/${output_abs#$root/}"

  docker run --rm -v "$root":/data jgraph/drawio \
    --export --format svg --output "$output_in_container" "$input_in_container"
}

if [[ "${USE_DOCKER_DRAWIO:-}" != "1" ]]; then
  if command -v drawio >/dev/null 2>&1; then
    if ! run_drawio; then
      echo "drawio export failed, trying docker fallback..." >&2
    fi
  fi
fi

if [[ ! -f "$OUTPUT_PATH" ]]; then
  if command -v docker >/dev/null 2>&1; then
    if ! run_docker; then
      echo "Docker export failed." >&2
    fi
  else
    echo "drawio CLI not available and docker not found." >&2
  fi
fi

if [[ ! -f "$OUTPUT_PATH" ]]; then
  echo "Export failed: $OUTPUT_PATH not created." >&2
  exit 1
fi
