# typed: false
# frozen_string_literal: true

cask "flashot" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.0"
  sha256 arm:   "77cbdfe5775de449dd47f0e51272db3ea22e36fc8806cc303c028c3f3758e33d",
         intel: "e140afa3a038fade623f5a51697878f0ec3baa6041da8f580516b64b0399db20"

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
