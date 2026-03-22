# Trip Adjustment

Travel expense tracking app for fast on-the-go capture, receipt-assisted draft entry, and trip-level budget visibility.

## Current status

This repository now tracks GitHub and includes a portable Obsidian vault. The product definition lives in Obsidian, and this repo contains the initial SwiftUI source skeleton that can be imported into Xcode on macOS later.

## Product focus

- iPhone-first SwiftUI app
- Fast manual expense entry
- Receipt OCR as draft suggestion, not full auto-save
- Multi-currency expense capture with trip base-currency aggregation
- Local-first storage in v1

## Repository layout

- `TripAdjustment/`: SwiftUI app source skeleton
- `ObsidianVault/`: portable Obsidian notes for the product and implementation plan
- `docs/`: local setup notes and Obsidian workflow

## Obsidian source of truth

- Vault root: `ObsidianVault/`
- App hub note: `ObsidianVault/어플/어플 1.md`

## Next steps on macOS

1. Create a new Xcode iOS App project named `TripAdjustment`.
2. Add the files under `TripAdjustment/` into the Xcode target.
3. Open `ObsidianVault/` as a vault in Obsidian on the Mac.
4. Replace the mock OCR and static conversion services with production implementations.
5. Add local persistence with SwiftData or Core Data.
