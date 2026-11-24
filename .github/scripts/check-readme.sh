#!/bin/sh
# Verify that the module list in README.md matches the --with lines in the
# Dockerfile.
# Usage: check-readme.sh [Dockerfile] [README.md]
set -eu

dockerfile=${1:-Dockerfile}
readme=${2:-README.md}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# github.com/owner/repo[/vN]@sha -> owner/repo
grep -oE -- '--with github\.com/[^@ ]+' "$dockerfile" \
  | sed -E 's#^--with github\.com/##; s#/v[0-9]+$##' \
  | LC_ALL=C sort -f > "$tmp/dockerfile"

# Links between the modules:start and modules:end markers -> owner/repo
sed -n '/<!-- modules:start -->/,/<!-- modules:end -->/p' "$readme" \
  | grep -oE '\(https://github\.com/[^)]+\)' \
  | sed -E 's#^\(https://github\.com/##; s#\)$##' \
  | LC_ALL=C sort -f > "$tmp/readme"

if [ ! -s "$tmp/readme" ]; then
  echo "No module list found between <!-- modules:start --> and <!-- modules:end --> in $readme" >&2
  exit 1
fi

if ! diff -u --label Dockerfile --label README.md "$tmp/dockerfile" "$tmp/readme"; then
  echo "README.md module list is out of sync with the Dockerfile" >&2
  exit 1
fi
echo "README.md lists all $(wc -l < "$tmp/dockerfile" | tr -d ' ') modules from the Dockerfile"
