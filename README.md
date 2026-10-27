# Portable Neovim

One config for Linux and macOS. Requires **Neovim 0.12+**; `vim.pack` is Neovim's
built-in plugin manager. The checked-in `nvim-pack-lock.json` pins plugin revisions.
Do not copy installed plugins, Mason binaries, caches or compiled parsers between
operating systems/CPU architectures. Each machine installs its own copies.

## Install on another machine

Copy this entire directory, including the lockfile and `lua/custom/palette.lua`,
to `~/.config/nvim`. It does not need `~/setup`, the rest of dotfiles, Stow or the
theme generator. If using XDG_CONFIG_HOME, put it in `$XDG_CONFIG_HOME/nvim`.
Back up an existing config first; do not merge blindly. For example, with this
folder unpacked as `./nvim`, run in Bash or Zsh:

```sh
config_parent="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_parent"
if [ -e "$config_parent/nvim" ] || [ -L "$config_parent/nvim" ]; then
  backup_dir="$(mktemp -d "$config_parent/nvim-backup.XXXXXX")"
  mv "$config_parent/nvim" "$backup_dir/nvim"
  echo "Previous config: $backup_dir/nvim"
fi
cp -a ./nvim "$config_parent/nvim"
nvim --version
nvim
```

First launch needs network access and confirmation for missing plugins. Plugin
build hooks run make for optional native modules; Mason installs configured
language tools and Treesitter builds parsers. Wait for installation to finish,
restart Neovim, then run `:checkhealth config`, `:checkhealth mason` and
`:checkhealth vimtex`. Missing optional tools are reported without pretending
their features work. A Nerd Font is recommended; otherwise set `nerd_font=false`.

### macOS prerequisites

Using an existing Homebrew installation, install missing components:

```sh
xcode-select --install  # only if Command Line Tools are not already installed
brew install neovim git ripgrep fd node python tree-sitter-cli
brew install --cask skim
```

Verify `nvim --version` is **0.12 or newer**. Older versions stop with an explicit
message; use `nvim --clean` as a fallback until upgraded. Homebrew's executable
paths on Apple Silicon and Intel are discovered when present.

For LaTeX, use your existing MacTeX installation, or install the full distribution
with `brew install --cask mactex-no-gui` (multi-GB download/install; review first).
Do not install alongside a conflicting BasicTeX/MacTeX distribution.
`/Library/TeX/texbin` is discovered automatically. Verify `latexmk`, `biber` and
the engines needed by your projects. Official package references:
[Neovim](https://formulae.brew.sh/formula/neovim),
[Skim](https://formulae.brew.sh/cask/skim),
[MacTeX](https://formulae.brew.sh/cask/mactex-no-gui).

### Linux prerequisites

Use your distribution's packages for Neovim 0.12+, Git, ripgrep, a C compiler,
make, unzip, Node.js, Python (including venv support), and tree-sitter-cli 0.26.1+.
The pinned Treesitter plugin's requirements also apply; check its README before
upgrading it. `fd` improves file finding but is optional. Wayland clipboard needs
wl-clipboard; X11 can use xclip/xsel. Over SSH without a clipboard provider,
ordinary Vim registers work normally.

For LaTeX install latexmk, biber and appropriate TeX Live packages plus Zathura
with a PDF backend. Existing Arch Perl executable directories are discovered
when present; they are never required on other distributions.

## Layout and customization

```text
init.lua                  version check and ordered module loading
lua/config/               options, keymaps, platform, settings, health, build hooks
lua/plugins/              UI, search, LSP, formatting, completion, Treesitter, extras
lua/custom/plugins/       VimTeX, Harpoon, startup, autoreload, optional Claude
lua/custom/palette.lua    bundled Fog palette; usable without a generator
lua/kickstart/plugins/    small supporting plugin configurations
local.example.lua         optional machine settings template
nvim-pack-lock.json       shared plugin revisions
```

Copy `local.example.lua` to `local.lua` for machine-specific preferences. It is
ignored by Git. Shared defaults live in `lua/config/settings.lua`; unknown keys
or wrong types fail clearly. Options: `nerd_font`, `auto_install`, `latex`, `ai`,
`viewer`, `python_host`, `claude`. Native Python editing uses project environments;
a Python provider is optional and only set when an explicit executable exists.
Claude integration is loaded only if its executable is found; no login is done.
Molten/notebook integration is not loaded. Historical notebook entries are retained
in the lockfile to preserve revisions; a fresh bootstrap may download them, but
this config does not activate them. Existing remote-plugin commands may remain
registered from older installations. Use Jupyter or Code for notebooks.

`auto_install=false` disables automatic Mason tool and Treesitter parser installs,
not vim.pack plugin bootstrap. For offline use, provision plugins/tools first.

## Same LaTeX workflow, native viewers

- Open `nvim main.tex`, then normal-mode **Space l v** to build and view.
- Save with `:w` to rebuild; **Space l v** jumps from source to PDF.
- **Space l e** shows errors; **Space l k** stops continuous compilation.
- Choose engines with `% !TeX program = xelatex` or `lualatex` in the root file.
- Linux uses Zathura; macOS uses Skim. Override `viewer` only if needed.

For Skim inverse search: Settings → Sync → Custom. Set Command to the output of
`command -v nvim` (often `/opt/homebrew/bin/nvim` or `/usr/local/bin/nvim`).
Arguments: `--headless -c "VimtexInverseSearch %line '%file'"`.
**Shift+Command+click** in Skim jumps back to Neovim. Linux Zathura uses Ctrl+click.
macOS may ask for automation permission when VimTeX controls Skim.

PDF dark mode belongs to the viewer, not Neovim. Existing Linux Zathura colors
are independent of this portable folder. Configure Skim appearance separately;
this config does not promise the same PDF filter on both platforms.

## Update and verify

`:lua vim.pack.update()` opens the plugin update review. Review changes before
accepting, then test and commit the lockfile. Do not delete the lockfile to update.
Update language tools separately through `:Mason`; inspect parser changes with
`:TSUpdate`. Native binaries are machine-local and are not pinned by vim.pack.

Portable decision checks (no plugin downloads):
`nvim --clean -l ~/.config/nvim/tests/portable.lua`.
Linux startup and existing keymaps are checked locally; macOS decisions are
simulated. Native Mac installation, rendering and Skim SyncTeX need a Mac check.
Pyright attachment could not be verified in the current agent environment: it
exits with both this config and the pre-refactor backup. Check Python LSP in a
normal terminal on each machine; basic editing and configured formatters remain
available independently of that server.

Rollback on a new machine: move the new config aside and restore the exact backup
directory printed above to its former location. Keep machine-local plugin data
unless you have a separate reason to remove it.
