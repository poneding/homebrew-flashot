# Homebrew Tap for Flashot

Install Flashot with Homebrew:

```sh
brew tap poneding/flashot
brew install --cask flashot
```

Flashot source code: <https://github.com/poneding/flashot>

## Updating the Cask

The main Flashot repository updates this tap automatically after non-prerelease GitHub Releases. If that automation fails, update the cask manually:

```sh
scripts/update-cask.sh v0.2.4 --commit --push
```

The script downloads the macOS ARM and Intel DMGs, computes their SHA256 hashes, updates `Casks/flashot.rb`, and optionally commits and pushes the change.
