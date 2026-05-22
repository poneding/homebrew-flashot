# typed: false
# frozen_string_literal: true

cask "flashot" do
  arch arm: "aarch64", intel: "x64"

  version "0.2.3"
  sha256 arm:   "f12c34bc0355f3aeb81b55f2ec449eba573340eb82d57a231d5d3c718965cc2d",
         intel: "0f4c8ef5330d8ad1fa49863d5f214c322198500a2ab8822e60a1cd234f82d113"

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
