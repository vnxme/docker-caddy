#!/bin/sh
# Check that a caddy binary was built for the expected ARM version.
# Usage: check-goarm.sh <path to caddy binary> <expected GOARM, e.g. 6>
set -eu

binary=$1
expected=$2

actual=$(go version -m "$binary" | awk '$1 == "build" && $2 ~ /^GOARM=/ {sub(/^GOARM=/, "", $2); print $2}')
echo "GOARM of $binary: ${actual:-<unset>}"
if [ "$actual" != "$expected" ]; then
  echo "Expected GOARM=$expected" >&2
  exit 1
fi
