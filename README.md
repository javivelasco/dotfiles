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

### Shared coding-agent instructions

Edit `agents/.agents/AGENTS.md` for global instructions shared by Pi, Claude Code,
Codex, OpenCode, and fx. The agent-specific files are relative symlinks to this one
canonical file, except for fx, which skips symlinked instruction files and gets a
copy from `./scripts/stow` instead:

| Agent | Stowed global instructions |
|---|---|
| Pi | `~/.pi/agent/AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex | `~/.codex/AGENTS.md` |
| OpenCode | `~/.config/opencode/AGENTS.md` |
| fx | `~/.fx/AGENTS.md` (copy) |

Commit and push changes to the shared file. On another machine, pull this repo
and run `./scripts/stow`. In Pi, run `/reload`; restart other agents to reload
their instructions. These links assume the default agent config directories;
custom config locations need corresponding links. Global `AGENTS.override.md`
files can supersede the shared instructions in Pi and Codex. Other coding agents
need an adapter for their own supported global-instructions location.

### Claude Code

Configuration for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI.

**`claude` package** manages `~/.claude/`:

- `settings.json` - Model preferences and permissions
- `CLAUDE.md` - Symlink to the shared coding-agent instructions
- `lessons.md` - Patterns learned from corrections (self-improvement loop)
- `agents/` - Custom subagents (software-architect, linear-* integrations)
- `rules/` - Personal coding rules (modular .md files)

Runtime data (history, cache, telemetry, todos) is excluded via `.stow-local-ignore` and remains local to each machine. The stow script pre-creates `~/.claude` as a real directory so runtime data never lands inside this repo.

**`agents` package** manages `~/.agents/`:

- `AGENTS.md` - Canonical global instructions shared by the coding-agent packages
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

### Pi

The `pi` package manages `~/.pi/agent/settings.json`, the shared `AGENTS.md` link,
a custom Gruvbox theme, and a local sound-notification extension.
The settings include the default model, reasoning level, and installed Pi packages.
Runtime and machine-local data (`auth.json`, `trust.json`, sessions, model caches,
and installed package files) stays outside the repository.

Pi is installed in the active `fnm` Node environment. After installing an LTS
Node version, install Pi and authenticate the configured provider:

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
pi
/login  # Select Vercel AI Gateway
```

On startup, Pi reads the stowed settings and installs the configured
`pi-web-access` package if it is missing. Shared agent skills belong under
`agents/.agents/skills/`, which Pi discovers automatically through
`~/.agents/skills/`.

The sound extension uses macOS Glass at 25% volume when the agent fully settles
and Pop when a blocking question or dialog opens during work. Tool activity,
aborted runs, manually opened menus, and non-interactive sessions stay silent.
After stowing, run `/reload` in Pi. Preview with `/sound-test done` or
`/sound-test input`. Run its regression tests with Node 24:

```bash
node --test tests/pi-sounds.test.mjs
```

### fx

The `fx` package manages only `~/.fx/themes/gruvbox-dark.json`, a Gruvbox theme
matching the Ghostty and Pi palettes. Fish selects it with `FX_THEME`, so
`~/.fx/settings.json` stays machine-local. The stow script keeps `~/.fx` as a
real directory so credentials, sessions, and other runtime data stay outside the
repository.

### macOS settings

System settings (key repeat, Dock, Finder) live declaratively in `macos-defaults/` and are applied by `./setup` using [macos-defaults](https://github.com/dsully/macos-defaults) (installed from the Brewfile). To apply manually after editing:

```bash
macos-defaults apply ./macos-defaults
```

### OpenCode

The `opencode` package manages `~/.config/opencode/opencode.json` (MCP servers and preferences) and the shared `AGENTS.md` link. Runtime data (auth, node_modules, machine-local skills) stays out of the repo.

### Codex

The `codex` package manages only `~/.codex/AGENTS.md`, linked to the shared
instructions. The stow script keeps `~/.codex` as a real directory so credentials,
sessions, and other machine-local data stay outside the repository.

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
