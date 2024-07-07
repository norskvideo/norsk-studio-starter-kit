#!/usr/bin/env bash
set -eo pipefail
cd "${0%/*}"

wget -O ../mnt/data/whisper-models/ggml-tiny.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin