#!/bin/sh
# Check that a built image runs, reports the expected Caddy version and
# contains every module from the Dockerfile.
# Usage: smoke-test.sh <image> [Dockerfile]
set -eu

image=$1
dockerfile=${2:-Dockerfile}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

expected_version=v$(sed -n 's/^ARG CADDY_VERSION=//p' "$dockerfile")
actual_version=$(docker run --rm "$image" caddy version | awk '{print $1}')
echo "Caddy version: $actual_version"
if [ "$actual_version" != "$expected_version" ]; then
  echo "Expected Caddy $expected_version, got $actual_version" >&2
  exit 1
fi

grep -oE -- '--with [^@ ]+' "$dockerfile" | awk '{print $2}' \
  | LC_ALL=C sort -u > "$tmp/expected"

# Lines look like "<module id> <go module path>"; keep the path.
docker run --rm "$image" caddy list-modules --packages --skip-standard \
  | awk 'NF >= 2 && $2 ~ /\// {print $2}' \
  | LC_ALL=C sort -u > "$tmp/actual"

missing=$(LC_ALL=C comm -23 "$tmp/expected" "$tmp/actual")
if [ -n "$missing" ]; then
  echo "Modules missing from the image:" >&2
  echo "$missing" >&2
  exit 1
fi
echo "All $(wc -l < "$tmp/expected" | tr -d ' ') modules are present:"
cat "$tmp/actual"
