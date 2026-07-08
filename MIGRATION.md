# Machine Migration Checklist (dev environment Mac to Mac)

Repeatable checklist for moving this dev setup to a new Mac. This covers the
terminal / `~/.config` world. For everything else (documents, browsers, GUI apps,
macOS settings, Setapp, etc.) see [`docs/machine-migration.md`](docs/machine-migration.md).

## How this setup travels

`~/.config` is this git repo (`github.com:AlexAxthelm/config.git`). Cloning it +
running `symlink.sh` restores almost everything, because:

- Configs live under XDG (`$XDG_CONFIG_HOME` = `~/.config`).
- Plugin managers auto-install on first run: **antidote** (zsh), **lazy** (nvim),
  **TPM** (tmux).

So the real work is the **gaps** — secrets and toolchains that are deliberately not in
the repo — plus a few machine-specific paths to reconcile.

**Toolchain philosophy:** install version managers *clean* (pyenv, rustup, ruby,
`fnm`, `uv`, `pipx`) with at most one current default each. Do **not** copy version
lists from the old Mac — projects install their own pinned versions on demand as
they're brought over.

---

## A. On the OLD Mac — capture what git won't carry

- [ ] Commit & push any local `~/.config` changes. `vgm` opens all modified/untracked
      files for review, then `git commit` && `git push`.
- [ ] Generate the Brewfile (source of truth is this machine):
      `brew bundle dump --file ~/.config/Brewfile --describe --force`
      then curate it (drop stale/one-off tools) and commit.
- [ ] Securely transfer secrets NOT in git — copy machine-to-machine (AirDrop/scp),
      **never** through the repo:
  - [ ] `~/.config/shell/exports_private.sh` — holds `GITHUB_TOKEN`. Better: recreate
        with a fresh PAT on the new Mac (see §B) and revoke this one at decommission.
  - [ ] `~/.config/R/Renviron` — R GitHub PAT (only if you use R).
  - [ ] `~/.ssh/` — private keys + `config`. Or generate fresh keys on the M5 (cleaner).
  - [ ] GPG keyring, if any: `gpg --export-secret-keys`.
- [ ] Light inventory (which *tools*, not versions): `pipx list`, `uv tool list`,
      `gh extension list`. You'll reinstall the managers clean and let projects pin versions.
- [ ] Note local data not in cloud/git: repos with uncommitted work, local Postgres
      (`postgresql@14`) databases, Docker images/volumes, project `.env` files.

## B. On the NEW Mac — setup (order matters)

- [ ] Xcode Command Line Tools: `xcode-select --install`, then install Homebrew.
- [ ] SSH: restore or generate keys, `ssh-add`, add the public key to GitHub.
      *(Needed before cloning the SSH remote.)*
- [ ] Clone config: `git clone git@github.com:AlexAxthelm/config.git ~/.config`
- [ ] Run `~/.config/symlink.sh` → creates `~/.zshrc`, `~/.cspell.json`, `~/.finicky.js`.
- [ ] Install everything from the curated Brewfile:
      `brew bundle install --file ~/.config/Brewfile`
- [ ] Recreate `~/.config/shell/exports_private.sh` with a **new** `GITHUB_TOKEN`
      (don't reuse the old PAT).
- [ ] Recreate `~/.config/R/Renviron` from `R/Renviron.example` with a fresh R PAT
      (only if you use R).
- [ ] Open a fresh `zsh` → antidote auto-installs zsh plugins.
- [ ] First-run plugin managers:
  - [ ] `nvim` → `:Lazy sync`, then `:Mason` to install language servers.
  - [ ] New tmux session → `prefix + I` (TPM installs plugins).
- [ ] Install version managers **clean** (via Brewfile where possible): pyenv, rustup,
      ruby, `fnm`, `uv`, `pipx`. Set at most one current default each.
- [ ] Reinstall only the standalone `uv tool` / `pipx` apps you actually use.
- [ ] Re-authenticate: `gh auth login`, GitHub Copilot, `az login` (azure-cli),
      any other cloud CLIs.
- [ ] **Node: nvm → fnm.** Remove the `NVM_DIR` block from `shell/zsh/zshrc` and the
      `NVM_DIR` lines from `shell/exports.sh`; add fnm's init hook instead:
      `eval "$(fnm env --use-on-cd)"`. fnm reads `.nvmrc` / `.node-version`, so
      per-project versions just work.
- [ ] Reconcile remaining machine-specific paths in `shell/exports.sh`: verify
      `openjdk@17`, the ruby gem path, and the powerline `python3.11` site-packages
      path all resolve on the M5.

## C. Verify (new Mac works)

- [ ] New login shell shows **no** `INFO: … not installed` warnings (from
      `alias.sh` / `exports.sh`).
- [ ] `git`, `gh auth status`, and a test `git push` all work over SSH.
- [ ] `nvim` opens with plugins + LSP loaded; `tmux` loads plugins.
- [ ] `echo $XDG_CONFIG_HOME` and `echo ${GITHUB_TOKEN:+set}` both non-empty;
      `brew doctor` is clean.

## D. Decommission the OLD Mac (last)

- [ ] Revoke the old GitHub PAT(s) and any device-scoped tokens.
- [ ] Sign out of iCloud, Setapp, App Store, and other licensed apps.
- [ ] Erase: System Settings → General → Transfer or Reset → Erase All Content and Settings.
