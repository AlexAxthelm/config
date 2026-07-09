# Machine migration — everything outside the dev environment

Companion to [`../MIGRATION.md`](../MIGRATION.md), which covers the terminal /
`~/.config` setup. This doc is the broader "don't forget these" list for the rest of
the machine. It's a clean-install migration (not Migration Assistant), so each area is
a deliberate transfer.

## Licensed / subscription apps

- [ ] **Setapp** — sign in on the M5, then reinstall only the apps you actually use
      (curate; don't bulk-install the whole catalog). Setapp itself is bootstrapped by
      the Brewfile (`cask "setapp"`); install the individual apps from within it. Apps to
      reinstall via Setapp (keep these OUT of the Brewfile):
  - [ ] **CleanShot X** (screen capture)
  - [ ] **CleanMyMac** (disk cleanup)
  - [ ] **Rectangle** (window manager — Rectangle Pro on Setapp)
  - [ ] **TripMode** (per-network data control)
- [ ] **Mac App Store** — reinstall the keepers. List current installs with
      `mas list` (install `mas` via brew first).
- [ ] Standalone licensed apps — gather license keys / sign-ins before wiping the old Mac
      (e.g. anything not from Setapp or the App Store).

## Data & files

- [ ] `~/Documents`, `~/Desktop`, `~/Downloads` — move what you want to keep.
- [ ] Code repos not pushed to GitHub — push or copy.
- [ ] Local databases — dump local Postgres (`postgresql@14`) if any data matters.
- [ ] Docker — rebuild images from Dockerfiles; export named volumes only if they hold
      real state.
- [ ] Project `.env` / secrets files living inside project dirs.

## Cloud drives

- [ ] iCloud Drive — sign in, let it sync.
- [ ] Dropbox / OneDrive / Google Drive — reinstall, sign in, confirm sync completes
      before erasing the old Mac.

## Browsers

- [ ] Sign in to browser account(s) to sync bookmarks, history, extensions.
- [ ] Re-add extensions that don't sync automatically.
- [ ] Saved logins — via account sync or password manager (below), not manual export.

## Secrets & accounts

- [ ] Password manager — install, sign in, verify vault.
- [ ] 2FA / authenticator seeds — migrate the authenticator app (many need explicit
      export/transfer *before* the old device is wiped). Do this early.
- [ ] VPN configs / profiles.
- [ ] `~/.ssh/known_hosts` (keys themselves are handled in `MIGRATION.md`).
- [ ] Cloud CLI credentials beyond what `az login` etc. re-establish.

## macOS system settings

- [ ] Keyboard & trackpad preferences (beyond Karabiner/LinearMouse, which are in the
      config repo).
- [ ] Dock, Finder preferences, Hot Corners, Mission Control.
- [ ] Displays — you have `displayplacer` (brew); can script the arrangement:
      `displayplacer list` on the old Mac to capture the current layout command.
- [ ] Login items / launch-at-startup apps.
- [ ] Default apps per file type / URL scheme (Finicky handles browser routing).
- [ ] Menu bar setup (Ice/Dozer/Thaw configs).

## Communications & media

- [ ] Mail / Calendar / Contacts accounts.
- [ ] Messages (sign in to iMessage; enable Messages in iCloud if used).
- [ ] Photos library — via iCloud Photos or manual copy of the `.photoslibrary`.

## Hardware & network

- [ ] Printers — re-add.
- [ ] Network drives / SMB shares — re-mount, save credentials.
- [ ] Bluetooth peripherals — re-pair.
