# Neovim Configuration

Personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
using the built-in **`vim.pack`** plugin manager (Neovim 0.12 or later).

Focused on **PHP/Symfony** and **TypeScript** development. System dependencies are managed
with Nix on every platform:

| Platform | Setup |
|----------|-------|
| macOS | [nix-darwin](https://github.com/nix-darwin/nix-darwin) |
| NixOS | NixOS configuration or Home Manager |
| Other Linux distributions | [Nix package manager](https://nixos.org/download/) (`nix profile` or standalone Home Manager) |

---

## Features

On top of the kickstart base (LSP, Treesitter, Telescope, which-key, gitsigns, conform,
blink.cmp, mini.nvim, ...), the following customizations live in
[`lua/custom/plugins/`](lua/custom/plugins):

| File | Purpose |
|------|---------|
| `keymaps.lua` | Keymaps following the [LazyVim](https://www.lazyvim.org/keymaps) layout |
| `flash.lua` | Jump anywhere on screen with `s` / `S` ([flash.nvim](https://github.com/folke/flash.nvim)) |
| `dashboard.lua` | Start screen ([snacks.nvim](https://github.com/folke/snacks.nvim)) with logo, recent files, projects, git status |
| `colorscheme.lua` | **Xcode Dark** theme ([vim-colors-xcode](https://github.com/arzg/vim-colors-xcode)) with a transparent background |
| `statusline.lua` | Statusline ([lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)) with git branch, diff and diagnostics |
| `bufferline.lua` | Tab bar at the top ([bufferline.nvim](https://github.com/akinsho/bufferline.nvim)) |
| `neotree-autoopen.lua` | Opens the **neo-tree** explorer on startup when inside a project |
| `autoreload.lua` | Reloads buffers changed on disk by external tools (coding agents, git) |
| `markdown.lua` | In-buffer Markdown rendering ([render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)) |
| `neogit.lua` | Git interface ([Neogit](https://github.com/NeogitOrg/neogit) + [diffview.nvim](https://github.com/sindrets/diffview.nvim)) |
| `which-key-theme.lua` | Aligns which-key colors and border with the theme |
| `snacks-theme.lua` | Aligns snacks floating windows (picker) with the editor background |

### Language servers

| Server | Language | Installed by |
|--------|----------|--------------|
| `intelephense` | PHP | Mason |
| `symfony_lsp` | Symfony (PHP, Twig, YAML, translations, ...) | Manual, see below |
| `vtsls` | TypeScript / JavaScript | Mason |
| `lua_ls` | Lua | Mason |
| `rust_analyzer` | Rust | rustup |

Formatters: `stylua` (Mason), `rustfmt` (rustup).

---

## Requirements

The configuration relies on a few external tools:

| Tool | Why |
|------|-----|
| `neovim` | 0.12 or later, for `vim.pack` |
| `nodejs` | Runs the Node-based servers installed by Mason (intelephense, vtsls) |
| `tree-sitter` | CLI used by nvim-treesitter to build parsers |
| `gcc`, `gnumake` | Compile Treesitter parsers |
| `ripgrep`, `fd` | Search (Telescope / snacks picker) |
| `git`, `curl`, `unzip`, `wget` | Plugin and Mason downloads |
| `lazygit` | Optional, alternative git UI (`<leader>gG` / `<leader>gL`) |
| A Nerd Font | Icons (dashboard, neo-tree, bufferline, statusline) |

### macOS (nix-darwin)

```nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim tree-sitter nodejs_24 gcc gnumake
    ripgrep fd git curl unzip wget lazygit
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
}
```

Apply with `darwin-rebuild switch --flake ~/.config/nix-darwin`.

### NixOS

Add the same packages to `environment.systemPackages` (or `home.packages` with Home Manager).
Mason downloads generic Linux binaries that cannot run on NixOS without a dynamic loader, so
enable `nix-ld` as well:

```nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim tree-sitter nodejs_24 gcc gnumake
    ripgrep fd git curl unzip wget lazygit
  ];

  programs.nix-ld.enable = true;   # lets Mason binaries run
}
```

Apply with `sudo nixos-rebuild switch --flake <path-to-your-flake>`.

### Other Linux distributions (Nix package manager)

Install [Nix](https://nixos.org/download/), then add the packages to your user profile:

```bash
nix profile add nixpkgs#{neovim,tree-sitter,nodejs_24,gcc,gnumake,ripgrep,fd,git,curl,unzip,wget,lazygit}
```

On older Nix versions, use `nix profile install` instead. Standalone Home Manager with the
same list in `home.packages` works too. Mason binaries run natively on these distributions,
so `nix-ld` is not needed.

### Nerd Font

Install the Nerd Font on the machine that runs the terminal (for example
`nerd-fonts.jetbrains-mono` via nix-darwin), then select **JetBrainsMono Nerd Font** in the
terminal (Ghostty, WezTerm, Kitty, ...). Without it, icons render as empty boxes.

### Symfony language server

[Symfony Language Tools](https://github.com/symfony/language-tools) is not packaged in nixpkgs.
Download the archive for your platform from the
[releases page](https://github.com/symfony/language-tools/releases) and put the `symfony-lsp`
binary on your `PATH`. If your Mason registry provides it, `:MasonInstall symfony-lsp` works too.

The server boots the Symfony kernel with `php bin/console`, so `php` must be on the `PATH`
of the Neovim process. With per-project PHP (devenv, direnv), start Neovim from the project
shell. It asks before executing application code in a workspace.

---

## Installation

```bash
# 1. (Optional) back up an existing configuration
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

# 2. Clone this configuration
git clone https://github.com/Gulivertx/nvim-dotfiles ~/.config/nvim

# 3. Start Neovim: vim.pack installs every plugin at the versions
#    pinned in nvim-pack-lock.json
nvim
```

On first launch:
- `vim.pack` downloads the plugins
- **Mason** installs the language servers and formatters
- Treesitter parsers are compiled

Then check that everything is healthy:

```vim
:checkhealth
:Mason                 " language servers and formatters
:checkhealth vim.lsp   " servers attached to the current buffer
```

### Intelephense Premium license (optional)

To enable Intelephense Premium, store the key in a file outside the repository:

```bash
mkdir -p ~/intelephense
echo -n "YOUR_LICENCE_KEY" > ~/intelephense/licence.txt
```

Intelephense reads this file automatically (spelled **`licence`**, with no trailing newline).

---

## Updating

### Plugins

```vim
:lua vim.pack.update()
```

A preview of the changes opens; write it with `:w` to apply the update. Then commit the
lockfile to pin the new versions:

```bash
cd ~/.config/nvim
git add nvim-pack-lock.json
git commit -m "chore: update plugins"
git push
```

`nvim-pack-lock.json` is **tracked by git**: it guarantees that every machine gets exactly the
same plugin versions. See `:help vim.pack-lockfile`.

To remove a plugin, delete its `vim.pack.add` call, then run
`:lua vim.pack.del({ 'plugin-name' })` so it is removed from disk and from the lockfile.

### Language servers and formatters

```vim
:MasonToolsUpdate
```

Or open `:Mason` and press `U` (shown only when updates are available). Mason tools live in
`~/.local/share/nvim/mason`, so nothing needs to be committed afterwards.

### Syncing between machines

```bash
cd ~/.config/nvim
git pull        # fetch the changes
nvim            # new plugins are installed at the lockfile revision
```

Then align the plugins already installed with the lockfile, and confirm with `:w`:

```vim
:lua vim.pack.update(nil, { target = 'lockfile' })
```

Plugins removed on the other machine stay on disk: delete them with `vim.pack.del()`
(see `git diff -- nvim-pack-lock.json` for their names).

---

## Key mappings

Keymaps follow the [LazyVim layout](https://www.lazyvim.org/keymaps), so its documentation
and cheat sheets apply. Telescope is used as the picker, and LazyVim plugins that are not
installed here (trouble, noice, grug-far, persistence, ...) have no mappings.

`<leader>` = **Space**. Press it and wait: **which-key** lists every group and mapping.
`<leader>sk` fuzzy-searches all of them.

| Group | Prefix |
|-------|--------|
| Buffers | `<leader>b` |
| Code / LSP | `<leader>c` |
| Files / find | `<leader>f` |
| Git (hunks under `<leader>gh`) | `<leader>g` |
| Search | `<leader>s` |
| UI toggles | `<leader>u` |
| Windows | `<leader>w` |
| Diagnostics / quickfix | `<leader>x` |
| Tabs | `<leader><tab>` |

The most useful ones:

| Mapping | Action |
|---------|--------|
| `<leader><space>` | Find files (project root) |
| `<leader>/` | Grep (project root) |
| `<leader>,` | Open buffers |
| `<leader>fr` | Recent files |
| `<leader>e` | Toggle neo-tree |
| `Shift+h` / `Shift+l` | Previous / next buffer |
| `<leader>bd` | Delete buffer |
| `gd` / `gr` | Go to definition / references |
| `K` | Hover documentation |
| `<leader>ca` / `<leader>cr` | Code action / rename |
| `<leader>cf` | Format |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next / previous diagnostic |
| `]h` / `[h` | Next / previous git hunk |
| `<leader>gg` / `<leader>gl` / `<leader>gf` | Neogit status / log / current file history |
| `<leader>gG` / `<leader>gL` | Lazygit / lazygit log |
| `s` | Flash jump |
| `gsa` / `gsd` / `gsr` | Add / delete / replace surrounding |
| `<C-s>` | Save |
| `<leader>-` / `<leader>\|` | Split below / right |
| `<leader>um` | Toggle Markdown rendering |
| `<leader>qq` | Quit all |

From the dashboard: `f` files, `g` grep, `r` recent, `p` projects, `c` config.

---

## Structure

```
~/.config/nvim/
├── init.lua                      # main configuration (kickstart, modified)
├── nvim-pack-lock.json           # pinned plugin versions (tracked by git)
├── lua/
│   ├── custom/plugins/           # customizations (see the table above)
│   │   └── init.lua              # loads every .lua file in this directory
│   └── kickstart/plugins/        # optional kickstart modules (neo-tree enabled)
└── README.md
```

Every `.lua` file placed in `lua/custom/plugins/` is loaded automatically on startup
(except `init.lua`). To add a plugin, create a file that calls
`vim.pack.add { 'https://github.com/...' }`, then `require('...').setup {}`.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `tree-sitter build ... ENOENT` | Install the `tree-sitter` CLI (see requirements) |
| Broken icons (empty boxes) | Select a **Nerd Font** in the terminal |
| Mason server fails to install | Check that `node`/`npm` are on the `PATH`: `:lua print(vim.fn.exepath('npm'))` |
| Mason server installed but does not start (NixOS) | Enable `programs.nix-ld.enable` |
| `symfony_lsp` not attached | Check that `symfony-lsp` and `php` are on the `PATH`, then `:checkhealth vim.lsp` |
| Plugin broken after an update | `git checkout HEAD -- nvim-pack-lock.json`, restart Neovim, then `:lua vim.pack.update({ 'plugin' }, { offline = true, target = 'lockfile' })` |

---

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), MIT license (see `LICENSE.md`).
