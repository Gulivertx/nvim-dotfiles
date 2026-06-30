# Configuration Neovim

Configuration personnelle de Neovim, basée sur [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
et utilisant le gestionnaire de plugins intégré **`vim.pack`** (Neovim ≥ 0.12).

Pensée pour un environnement **macOS + nix-darwin**, avec un focus sur le développement
**PHP/Symfony** et **TypeScript**.

---

## ✨ Ce que contient cette config

En plus de la base kickstart (LSP, Treesitter, Telescope, which-key, gitsigns, conform,
blink.cmp, mini.nvim…), les personnalisations suivantes ont été ajoutées dans
[`lua/custom/plugins/`](lua/custom/plugins) :

| Fichier | Rôle |
|---------|------|
| `dashboard.lua` | Écran d'accueil ([snacks.nvim](https://github.com/folke/snacks.nvim)) avec logo, fichiers récents, projets |
| `colorscheme.lua` | Thème **Xcode Dark** ([vim-colors-xcode](https://github.com/arzg/vim-colors-xcode)) — esthétique « macOS Dark » |
| `bufferline.lua` | Barre d'onglets en haut ([bufferline.nvim](https://github.com/akinsho/bufferline.nvim)) |
| `neotree-autoopen.lua` | Ouvre l'explorateur **neo-tree** au démarrage si on est dans un projet |
| `markdown.lua` | Rendu Markdown dans le buffer ([render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)) |
| `which-key-theme.lua` | Aligne les couleurs/bordure de which-key sur le thème |
| `snacks-theme.lua` | Aligne le fond des fenêtres snacks (picker) sur le fond de l'éditeur |

**LSP gérés via Mason** : `intelephense` (PHP/Symfony), `vtsls` (TypeScript),
`twiggy-language-server` (Twig), `lua_ls`, + formatters (`php-cs-fixer`, `prettier`, `stylua`).

---

## 📋 Prérequis

Cette config s'appuie sur des outils externes. Sur macOS avec **nix-darwin**, ajoute-les
à ta configuration (`environment.systemPackages`) :

```nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim        # ≥ 0.12 (pour vim.pack)
    nodejs_24     # dernière LTS — requis par Mason (intelephense, vtsls) et certains LSP
    tree-sitter   # CLI requis par nvim-treesitter
    ripgrep       # recherche (telescope / snacks picker)
    fd            # recherche de fichiers
    gcc           # compilation des parsers treesitter
    gnumake
    git
    curl
    unzip
    lazygit       # (optionnel) UI git
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono   # icônes (dashboard, neo-tree, bufferline…)
  ];
}
```

Puis applique : `darwin-rebuild switch --flake ~/.config/nix-darwin`

> ⚠️ Pense à sélectionner **JetBrainsMono Nerd Font** comme police dans ton terminal
> (WezTerm / Ghostty / Kitty) pour afficher correctement les icônes.

---

## 🚀 Installation sur un nouveau poste

```bash
# 1. (Optionnel) sauvegarder une éventuelle config existante
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

# 2. Cloner cette config
git clone <URL_DE_TON_REPO> ~/.config/nvim

# 3. Lancer Neovim : vim.pack installe automatiquement tous les plugins
#    aux versions figées dans nvim-pack-lock.json
nvim
```

Au premier lancement :
- `vim.pack` télécharge les plugins (barre de progression en bas)
- **Mason** installe les LSP/formatters (`intelephense`, `vtsls`, `twiggy`, `prettier`, `php-cs-fixer`…)
- Les parsers Treesitter se compilent

Vérifie ensuite que tout est sain :

```vim
:checkhealth
:Mason          " état des LSP/formatters
:LspInfo        " sur un fichier .php / .ts
```

### Licence Intelephense Premium (optionnel)

Pour activer Intelephense Premium, place ta clé dans un fichier (non versionné) :

```bash
mkdir -p ~/intelephense
echo -n "TA_CLE_DE_LICENCE" > ~/intelephense/licence.txt
```

Intelephense lit ce fichier automatiquement (orthographe **`licence`**, sans espace ni saut de ligne).

---

## 🔄 Mettre à jour

### Mettre à jour les plugins

```vim
:lua vim.pack.update()        " met à jour tous les plugins
```

Après une mise à jour qui te convient, **régénère et committe le lockfile** pour figer
les nouvelles versions :

```bash
cd ~/.config/nvim
git add nvim-pack-lock.json
git commit -m "chore: update plugins"
git push
```

> Le fichier `nvim-pack-lock.json` est **suivi par git** : c'est lui qui garantit que tous
> tes postes auront exactement les mêmes versions de plugins. Voir `:help vim.pack-lockfile`.

### Mettre à jour les LSP / formatters (Mason)

```vim
:Mason          " puis U pour tout mettre à jour
```

### Synchroniser ta config entre postes

```bash
cd ~/.config/nvim
git pull        # récupère les changements
nvim            # vim.pack ajuste les plugins selon le lockfile
```

---

## ⌨️ Raccourcis clés (en plus de kickstart)

`<leader>` = **barre d'espace**

| Raccourci | Action |
|-----------|--------|
| `\` | Ouvre / révèle l'explorateur **neo-tree** |
| `Tab` / `Shift+Tab` | Onglet (buffer) suivant / précédent |
| `<leader>1`…`9` | Aller à l'onglet N |
| `<leader>bp` | Choisir un onglet (pick) |
| `<leader>bd` | Fermer le buffer courant |
| `<leader>tm` | Basculer le rendu Markdown |
| `<leader>` (puis attendre) | **which-key** : affiche tous les raccourcis |
| `:Telescope keymaps` | Recherche floue de tous les raccourcis |

Depuis l'écran d'accueil (dashboard) : `f` fichiers · `g` grep · `r` récents · `p` projets · `c` config.

---

## 🗂️ Structure

```
~/.config/nvim/
├── init.lua                      # config principale (kickstart, modifiée)
├── nvim-pack-lock.json           # versions figées des plugins (suivi par git)
├── lua/
│   ├── custom/plugins/           # ⭐ personnalisations (voir tableau plus haut)
│   │   └── init.lua              # charge automatiquement tous les .lua du dossier
│   └── kickstart/plugins/        # modules optionnels kickstart (neo-tree activé, etc.)
└── README.md
```

> Tout fichier `.lua` déposé dans `lua/custom/plugins/` est chargé automatiquement
> au démarrage (sauf `init.lua`). Pour ajouter un plugin, crée un fichier qui appelle
> `vim.pack.add { 'https://github.com/...' }` puis `require('...').setup {}`.

---

## 🛠️ Dépannage

| Problème | Solution |
|----------|----------|
| `tree-sitter build … ENOENT` | Installe le CLI `tree-sitter` (voir prérequis nix) |
| Icônes cassées (carrés) | Active une **Nerd Font** dans le terminal |
| Mason : LSP ne s'installe pas | Vérifie que `node`/`npm` sont dans le PATH (`:lua print(vim.fn.exepath('npm'))`) |
| Plugin cassé après update | `:lua vim.pack.update()` puis restaure le lockfile via `git checkout nvim-pack-lock.json` |

---

Basé sur [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — licence MIT (voir `LICENSE.md`).
