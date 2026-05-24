# typed: false
# frozen_string_literal: true

cask "flashot" do
  arch arm: "aarch64", intel: "x64"

  version "0.4.0"
  sha256 arm:   "14eb756e552c22e5ccf9206b45d2212c785df9b89afcc9472843066d0ae0c8cb",
         intel: "9e446c7553bbb800588d75966bcc8a5f6f543c5bc3f795a0cf7e57205adadca0"

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
