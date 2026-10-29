#!/usr/bin/env bash
# Frozen image from this Dockerfile:
# mpampuch/kmerord_aa22b13_linux-amd64:1ea525ba3f53ce0c
# Build ID bd-1ea525ba3f53ce0c_1, linux/amd64, 2026-10-28.
set -euo pipefail
cd "$(dirname "$0")"
set -a
source "${HOME}/.secrets/seqera-platform.sh"
set +a
wave -f Dockerfile \
  --platform linux/amd64 \
  --freeze \
  --build-repo mpampuch/kmerord_aa22b13_linux-amd64 \
  --await 90m \
  --log-level DEBUG
