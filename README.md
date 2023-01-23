## Dotfiles 🏡

We use [Homebrew](https://brew.sh/) as dependency manager for Mac and [GNU Stow](https://www.gnu.org/software/stow/) to manage dotfiles. The very first step to source all configuration consists of installing both and then using `stow` to generate symlinks to the home folder.

The script `./scripts/homebrew` will take care of making sure Homebrew is installed and source the included `Brewfile` to install all dependencies (including Stow). Once that's done we can source all of the configuration files by running:

```bash
stow -t $HOME -v brew fish git nvim tmux
```

This should create all symlinks to all require configuration so then we can bootstrap the dependencies detailed below.

### Fish

[Fish](https://github.com/fish-shell/fish-shell) is the shell of preference at the moment and it is installed from Homebrew. Once installed we have to make it the default one and install [Fisher](https://github.com/jorgebucaran/fisher), the plugin manager following instructions from the Github repository. Finally we can run `fisher update` to make sure all plugins get installed.

### Nvim

There is not a lot of special things on setting up `nvim`. After installing all `brew` dependencies it should be already there. Dependencies are managed with [Packer]() so it's just a matter of going to the `packer.lua` file and sourcing (`:so`) and then running `:PackerSync`.

### Tmux

To manage `tmux` dependencies we are using [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) so the first step is to install it. Once it is there it's we can simply run the Prefix plus capital I to install (`<C-b>I`).

## A note on Homebrew

To track installed dependencies and source every installed packages we use a `Brewfile` so keeping it updated is important. To make sure `Brewfile` is up to date we can periodically run:

```bash
brew bundle dump --global --force
```

As an alternative to installing packages and then dumping, can we directly install with `install` and uninstall with `remove`:

```bash
brew bundle --global install <formula>
```
