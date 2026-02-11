## Dotfiles 🏡

We use [Homebrew](https://brew.sh/) as dependency manager for Mac and [GNU Stow](https://www.gnu.org/software/stow/) to manage dotfiles. The very first step to source all configuration consists of installing both and then using `stow` to generate symlinks to the home folder.

The script `./scripts/homebrew` will take care of making sure Homebrew is installed and source the included `Brewfile` to install all dependencies (including Stow). Once that's done we can source all of the configuration files by running:

```bash
stow -t $HOME -v brew fish git nvim tmux aerospace ghostty starship yazi claude agents
```

This should create all symlinks to all require configuration so then we can bootstrap the dependencies detailed below.

### Claude Code

Configuration for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI.

**`claude` package** manages `~/.claude/`:

- `settings.json` - Model preferences and permissions
- `CLAUDE.md` - Personal memory/instructions for all projects
- `agents/` - Custom subagents (software-architect, linear-* integrations)
- `rules/` - Personal coding rules (modular .md files)

Runtime data (history, cache, telemetry, todos) is excluded via `.stow-local-ignore` and remains local to each machine.

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

### Fish

[Fish](https://github.com/fish-shell/fish-shell) is the shell of preference at the moment and it is installed from Homebrew. Once installed we have to make it the default one and install [Fisher](https://github.com/jorgebucaran/fisher), the plugin manager following instructions from the Github repository. Finally we can run `fisher update` to make sure all plugins get installed.

### Nvim

There is not a lot of special things on setting up `nvim`. After installing all `brew` dependencies it should be already there. Dependencies are managed with [lazy.nvim](https://github.com/folke/lazy.nvim) which bootstraps itself automatically on first launch and syncs plugins.

### Tmux

To manage `tmux` dependencies we are using [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) so the first step is to install it. Once it is there we can simply run the Prefix plus capital I to install (`<C-s>I`).

## A note on Homebrew

To track installed dependencies and source every installed packages we use a `Brewfile` so keeping it updated is important. To make sure `Brewfile` is up to date we can periodically run:

```bash
brew bundle dump --global --force
```

Alternatively, add formulas directly to the `.Brewfile` and run:

```bash
brew bundle --global
```
