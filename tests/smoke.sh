#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

for file in "$repo_dir"/install.sh "$repo_dir"/bin/macutil "$repo_dir"/scripts/*; do
  bash -n "$file"
done

MACOS_TOOLKIT_BIN_DIR="$test_root/bin" \
MACOS_TOOLKIT_RC_FILE="$test_root/zshrc" \
  "$repo_dir/install.sh"

PATH="$test_root/bin:$PATH" macutil help >/dev/null

for command_name in macutil memstats sysinfo diskcheck portcheck devcheck; do
  test -x "$test_root/bin/$command_name"
done

echo "Smoke tests passed"

