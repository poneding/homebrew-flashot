#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CASK_FILE="$ROOT_DIR/Casks/flashot.rb"
SOURCE_REPO="poneding/flashot"
ASSET_DIR=""
COMMIT=0
PUSH=0

usage() {
  cat <<'USAGE'
Usage: scripts/update-cask.sh <version|tag> [options]

Updates Casks/flashot.rb from Flashot release DMGs.

Options:
  --asset-dir <dir>   Use existing DMGs from a directory instead of downloading
  --cask-file <path>  Update a custom cask file, useful for tests
  --commit            Commit the cask update
  --push              Push after committing
  --repo <owner/repo> Source GitHub repo for release assets
  -h, --help          Show this help

Examples:
  scripts/update-cask.sh v0.2.4
  scripts/update-cask.sh 0.2.4 --commit --push
USAGE
}

need_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

version_input=""

while (($#)); do
  case "$1" in
    --asset-dir)
      ASSET_DIR="${2:-}"
      shift 2
      ;;
    --cask-file)
      CASK_FILE="${2:-}"
      shift 2
      ;;
    --commit)
      COMMIT=1
      shift
      ;;
    --push)
      COMMIT=1
      PUSH=1
      shift
      ;;
    --repo)
      SOURCE_REPO="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -n "$version_input" ]]; then
        echo "Unexpected argument: $1" >&2
        usage >&2
        exit 1
      fi
      version_input="$1"
      shift
      ;;
  esac
done

if [[ -z "$version_input" ]]; then
  usage >&2
  exit 1
fi

VERSION="${version_input#v}"
TAG="v$VERSION"

if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+([-.][0-9A-Za-z.-]+)?$ ]]; then
  echo "Version must look like 1.2.3 or v1.2.3, got: $version_input" >&2
  exit 1
fi

need_command shasum
need_command ruby

if [[ -z "$ASSET_DIR" ]]; then
  need_command curl
  ASSET_DIR="$(mktemp -d)"
  cleanup_asset_dir=1
else
  cleanup_asset_dir=0
fi

if (( COMMIT || PUSH )); then
  need_command git
fi

if (( cleanup_asset_dir )); then
  trap 'rm -rf "$ASSET_DIR"' EXIT
fi

AARCH64_ASSET="Flashot_${VERSION}_aarch64.dmg"
X64_ASSET="Flashot_${VERSION}_x64.dmg"
AARCH64_DMG="$ASSET_DIR/$AARCH64_ASSET"
X64_DMG="$ASSET_DIR/$X64_ASSET"

download_asset() {
  local asset="$1"
  local output="$2"
  local url="https://github.com/$SOURCE_REPO/releases/download/$TAG/$asset"

  echo "Downloading $url"
  curl -fL --retry 3 --retry-delay 2 -o "$output" "$url"
}

if [[ ! -f "$AARCH64_DMG" ]]; then
  download_asset "$AARCH64_ASSET" "$AARCH64_DMG"
fi

if [[ ! -f "$X64_DMG" ]]; then
  download_asset "$X64_ASSET" "$X64_DMG"
fi

AARCH64_SHA="$(shasum -a 256 "$AARCH64_DMG" | awk '{print $1}')"
X64_SHA="$(shasum -a 256 "$X64_DMG" | awk '{print $1}')"

ruby - "$CASK_FILE" "$VERSION" "$AARCH64_SHA" "$X64_SHA" <<'RUBY'
path, version, arm_sha, intel_sha = ARGV
content = File.read(path)

version_changed = content.sub!(/version "[^"]+"/, %(version "#{version}"))
sha_changed = content.sub!(
  /sha256 arm:\s+"[^"]+",\n\s+intel:\s+"[^"]+"/,
  %(sha256 arm:   "#{arm_sha}",\n         intel: "#{intel_sha}")
)

raise "Could not replace version in #{path}" unless version_changed
raise "Could not replace sha256 block in #{path}" unless sha_changed

File.write(path, content)
RUBY

ruby -c "$CASK_FILE" >/dev/null

echo "Updated $CASK_FILE"
echo "  version: $VERSION"
echo "  aarch64: $AARCH64_SHA"
echo "  x64:     $X64_SHA"

if (( COMMIT )); then
  git -C "$ROOT_DIR" add "$CASK_FILE"
  if git -C "$ROOT_DIR" diff --cached --quiet -- "$CASK_FILE"; then
    echo "No cask changes to commit"
  else
    git -C "$ROOT_DIR" commit -m "chore: update flashot to $VERSION"
  fi
fi

if (( PUSH )); then
  git -C "$ROOT_DIR" push
fi
