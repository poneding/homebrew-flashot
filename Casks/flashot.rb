# typed: false
# frozen_string_literal: true

cask "flashot" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.0"
  sha256 arm:   "58d419b0a463ac7e5d56561222e337c9641c2a69eb037bcff5db76f6161d1b48",
         intel: "07e33ebc866a03290319481f7516403e2f55105fe0618fb568b37828e7fe43d6"

  url "https://github.com/poneding/flashot/releases/download/v#{version}/Flashot_#{version}_#{arch}.dmg",
      verified: "github.com/poneding/flashot/"
  name "Flashot"
  desc "Fast, cross-platform screenshot tool"
  homepage "https://github.com/poneding/flashot"

  depends_on macos: ">= :monterey"

  app "Flashot.app"

  zap trash: [
    "~/Library/Application Support/dev.flashot.app",
    "~/Library/Caches/dev.flashot.app",
    "~/Library/Preferences/dev.flashot.app.plist",
    "~/Library/Saved Application State/dev.flashot.app.savedState",
  ]
end
