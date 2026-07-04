## Dotfiles 🏡

We use [Homebrew](https://brew.sh/) as dependency manager for Mac and [GNU Stow](https://www.gnu.org/software/stow/) to manage dotfiles.

Migrating to a brand new machine? Follow [MIGRATION.md](MIGRATION.md) — it covers everything the dotfiles can't (keys, auth, app data).

### Setting up a new machine

```bash
git clone https://github.com/javivelasco/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles

# Everything at once (homebrew + stow, then prints the manual steps):
./setup

# ...or step by step:

# 1. Install Homebrew + all dependencies from the Brewfile (includes stow
#    and fish) and make fish the default shell
./scripts/homebrew

# 2. Symlink every dotfile package into $HOME
#    (safe to re-run anytime; it prunes stale links too)
./scripts/stow

# 3. Create the machine-local secret files (gitignored, never committed)
cat > git/.gitconfig.user <<'EOF'
[user]
	name = Your Name
	email = you@example.com

# Commit signing via 1Password (macOS only — omit on remote boxes)
[gpg]
	format = ssh
[gpg "ssh"]
	program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
[commit]
	gpgsign = true
EOF
touch fish/.config/fish/config-secret.fish  # tokens/env vars, optional

# 4. Re-run stow so the new secret files get linked
./scripts/stow
```

Then finish the per-tool bootstrap steps below (Fish, Tmux, Yazi).

> The list of stowed packages lives in `./scripts/stow` — update it there
> when adding or removing a package.

### Remote Linux box (EC2)

For a terminal-only dev box, use the minimal bootstrap instead of `./setup`. It installs the essentials (nvim from the official tarball, tmux, node for LSPs) and stows only the portable packages (`git`, `nvim`, `tmux`):

```bash
git clone https://github.com/javivelasco/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles && ./scripts/remote
```

Clipboard works over SSH: tmux uses OSC 52 (`set-clipboard on`) and neovim auto-detects it, so yanks land on your local clipboard through ghostty.

### Claude Code

Configuration for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI.

**`claude` package** manages `~/.claude/`:

- `settings.json` - Model preferences and permissions
- `CLAUDE.md` - Personal memory/instructions for all projects
- `lessons.md` - Patterns learned from corrections (self-improvement loop)
- `agents/` - Custom subagents (software-architect, linear-* integrations)
- `rules/` - Personal coding rules (modular .md files)

Runtime data (history, cache, telemetry, todos) is excluded via `.stow-local-ignore` and remains local to each machine. The stow script pre-creates `~/.claude` as a real directory so runtime data never lands inside this repo.

**`agents` package** manages `~/.agents/`:

- `skills/` - Reusable AI agent skills from [skills.sh](https://skills.sh/)
- `.skill-lock.json` - Tracks skill sources and versions for updates

Skills are managed via the [skills CLI](https://skills.sh/):

```bash
npx skills list -g          # List installed global skills
npx skills check            # Check for updates
npx skills update           # Update all skills
npx skills add <repo> -g    # Install a skill globally
npx skills find <query>     # Search for skills
```

After stowing on a new machine, verify skill state:

```bash
npx skills check
npx skills update
```

### macOS settings

System settings (key repeat, Dock, Finder) live declaratively in `macos-defaults/` and are applied by `./setup` using [macos-defaults](https://github.com/dsully/macos-defaults) (installed from the Brewfile). To apply manually after editing:

```bash
macos-defaults apply ./macos-defaults
```

### OpenCode

The `opencode` package manages `~/.config/opencode/opencode.json` (MCP servers and preferences). Runtime data (auth, node_modules, machine-local skills) stays out of the repo.

### Fish

[Fish](https://github.com/fish-shell/fish-shell) is the shell of preference at the moment and it is installed from Homebrew (`./scripts/homebrew` also makes it the default shell). Then install [Fisher](https://github.com/jorgebucaran/fisher), the plugin manager, following instructions from the Github repository. Finally run `fisher update` to install all plugins from the stowed `fish_plugins` file.

Machine-local secrets (tokens, private env vars) go in `fish/.config/fish/config-secret.fish` — it is gitignored and sourced automatically when present.

### Git

Identity and any other personal git config live in `git/.gitconfig.user`, which is included from `.gitconfig` and gitignored so it never gets committed. Create it on each machine (see setup above).

### Nvim

There is not a lot of special things on setting up `nvim`. After installing all `brew` dependencies it should be already there. Dependencies are managed with [lazy.nvim](https://github.com/folke/lazy.nvim) which bootstraps itself automatically on first launch and syncs plugins. LSP servers and tools are installed automatically by mason on first launch too.

### Tmux

Dependencies are managed with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm). On a fresh machine tpm and all plugins install themselves automatically the first time tmux starts. To install/update plugins manually use Prefix plus capital I (`<C-s>I`) or U.

### Yazi

The theme flavor (`gruvbox-dark`) is managed by yazi's package manager and gitignored, so on a new machine install it from the tracked `package.toml`:

```bash
ya pkg install
```

## A note on Homebrew

To track installed dependencies and source every installed packages we use a `Brewfile` so keeping it updated is important. To make sure `Brewfile` is up to date we can periodically run:

```bash
brew bundle dump --global --force
```

Alternatively, add formulas directly to the `.Brewfile` and run:

```bash
brew bundle --global
```
