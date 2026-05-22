# typed: false
# frozen_string_literal: true

cask "flashot" do
  arch arm: "aarch64", intel: "9aa2d637f307451296b00fb1d093006d260cdb5dd303c53e64e1a63dd0b476f9"

  version "0.3.0"
  sha256 arm:   "e05101556987ca84c0d3d8bfdb27a2fb8d568db92eb58a77c8d6904775ee7462",
         intel: "9aa2d637f307451296b00fb1d093006d260cdb5dd303c53e64e1a63dd0b476f9"

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
