#!/usr/bin/env bash
# Transcribe a lesson recording with mlx-whisper into transcripts/.
#
# Flags were tuned against real bilingual (IT/PL) tutoring recordings:
# - HF_HUB_DISABLE_XET=1: the HF "xet" download backend was extremely slow/
#   flaky for this model; plain HTTP download is fast and reliable.
# - no --language: the audio mixes Italian and Polish, forcing one language
#   biases decoding for the other.
# - --condition-on-previous-text False + --hallucination-silence-threshold 2
#   (needs --word-timestamps True): without these, long silences make the
#   model get stuck repeating a single word/phrase for minutes.
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <input-audio-or-video-file> [output-basename]" >&2
  exit 1
fi

INPUT="$1"
BASENAME="${2:-$(basename "$INPUT" | sed -E 's/\.[^.]+$//')}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTDIR="$REPO_ROOT/transcripts"

mkdir -p "$OUTDIR"

HF_HUB_DISABLE_XET=1 mlx_whisper \
  --model mlx-community/whisper-large-v3-turbo \
  --output-format all \
  --output-dir "$OUTDIR" \
  --output-name "$BASENAME" \
  --verbose False \
  --word-timestamps True \
  --hallucination-silence-threshold 2 \
  --condition-on-previous-text False \
  "$INPUT"

echo "Transkrypcja zapisana w $OUTDIR/$BASENAME.*"
