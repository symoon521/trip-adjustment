# Local setup

## Why there is no Xcode project yet

This machine does not have Xcode or the Swift iOS toolchain installed, so the repository is prepared as a source-first scaffold instead of a generated `.xcodeproj`.

## Recommended setup on macOS

1. Open Xcode and create a new iOS App named `TripAdjustment`.
2. Set the interface to `SwiftUI` and the language to `Swift`.
3. Open `ObsidianVault/` with Obsidian so product notes move with the repo.
4. Remove the generated sample files you do not need.
5. Add the contents of the local `TripAdjustment/` folder into the app target.
6. Keep the product notes in Obsidian as the decision log.

## Recommended first implementation tasks

1. Wire `AppState` into the generated app entry point.
2. Replace the mock trip and expense data with SwiftData-backed repositories.
3. Implement camera capture and Vision-based receipt parsing.
4. Add exchange-rate snapshot persistence at expense save time.
