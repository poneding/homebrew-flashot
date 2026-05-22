#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/update-cask.sh"

assert_contains() {
  local file="$1"
  local expected="$2"

  if ! grep -Fq "$expected" "$file"; then
    echo "Expected $file to contain:" >&2
    echo "  $expected" >&2
    echo "Actual contents:" >&2
    cat "$file" >&2
    exit 1
  fi
}

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cask_file="$tmp_dir/flashot.rb"
asset_dir="$tmp_dir/assets"
mkdir -p "$asset_dir"

cat > "$cask_file" <<'RUBY'
# typed: false
# frozen_string_literal: true

cask "flashot" do
  arch arm: "aarch64", intel: "x64"

  version "0.1.0"
  sha256 arm:   "old-arm-sha",
         intel: "old-intel-sha"

  url "https://github.com/poneding/flashot/releases/download/v#{version}/Flashot_#{version}_#{arch}.dmg",
      verified: "github.com/poneding/flashot/"
end
RUBY

printf "arm fixture\n" > "$asset_dir/Flashot_1.2.3_aarch64.dmg"
printf "intel fixture\n" > "$asset_dir/Flashot_1.2.3_x64.dmg"

expected_arm_sha="$(shasum -a 256 "$asset_dir/Flashot_1.2.3_aarch64.dmg" | awk '{print $1}')"
expected_intel_sha="$(shasum -a 256 "$asset_dir/Flashot_1.2.3_x64.dmg" | awk '{print $1}')"

bash -n "$SCRIPT"
"$SCRIPT" v1.2.3 --cask-file "$cask_file" --asset-dir "$asset_dir"

assert_contains "$cask_file" 'version "1.2.3"'
assert_contains "$cask_file" "sha256 arm:   \"$expected_arm_sha\","
assert_contains "$cask_file" "       intel: \"$expected_intel_sha\""
assert_contains "$cask_file" 'Flashot_#{version}_#{arch}.dmg'

echo "update-cask.sh test passed"
