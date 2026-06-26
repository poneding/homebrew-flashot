# typed: false
# frozen_string_literal: true

cask "flashot" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.5"
  sha256 arm:   "400e0f91a0d3bd3b939713ff745ba7bb386cc78534a83aa32d069b99fe4e1316",
         intel: "3ead88e43d2f7b12e5703818c1fa92af94c90a20000873f1368a6bbf34944498"

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
