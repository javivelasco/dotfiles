# New machine migration checklist

Everything the dotfiles can't do for you. Work through it top to bottom.

## Before leaving the old machine

- [ ] Update the Brewfile with reality: `brew bundle dump --global --force`, review the diff, commit
- [ ] Check for uncommitted/unpushed work across all repos:

  ```bash
  for d in ~/Code/*/.git; do
    r=$(dirname "$d")
    (cd "$r" && [ -n "$(git status --porcelain)" ] && echo "DIRTY: $r")
    (cd "$r" && [ -n "$(git log --branches --not --remotes --oneline 2>/dev/null)" ] && echo "UNPUSHED: $r")
  done
  ```

- [ ] Copy `.env` / `.env.local` files from active projects (they're gitignored):

  ```bash
  find ~/Code -maxdepth 3 -name ".env*" -not -path "*/node_modules/*"
  ```

- [ ] Export Raycast settings (Raycast → Settings → Advanced → Export)
- [ ] Note apps installed outside brew/MAS (check `/Applications` against the Brewfile);
      corporate apps (Okta, SentinelOne, Falcon, Iru) come from MDM automatically

## Files to copy (never in git)

| What          | Path                                                         | Notes                                                      |
| :------------ | :----------------------------------------------------------- | :--------------------------------------------------------- |
| SSH keys      | `~/.ssh/` (`id_ed25519*`, `javi.pem`, `config`)              | Or import keys into 1Password and let the agent serve them |
| AWS           | `~/.aws/`                                                    | Credentials + config                                       |
| Kube contexts | `~/.kube/config`                                             | If clusters still relevant                                 |
| GPG           | `~/.gnupg/`                                                  | Only if you still use GPG Keychain                         |
| Git identity  | `git/.gitconfig.user` (in the repo working tree, gitignored) | Recreate from template in README                           |
| Fish secrets  | `~/.config/fish/config-secret.fish`                          | Tokens, private aliases (e.g. ec2-iad)                     |

## On the new machine

1. Install 1Password first (App Store or `brew install --cask 1password`), sign in,
   enable the SSH agent → git signing works immediately
2. `git clone git@github.com:javivelasco/dotfiles.git ~/Code/dotfiles && cd ~/Code/dotfiles`
3. `./setup` (Homebrew + Brewfile + stow; sign into the App Store first so `mas` works)
4. Recreate the secret files (README "Setting up a new machine" step 3), re-run `./scripts/stow`
5. Auth logins: `gh auth login`, `vercel login`, `claude` (first run), `opencode auth login`,
   `aws sso login` / aws-vault, `gcloud auth login`
6. Fish: install [fisher](https://github.com/jorgebucaran/fisher), then `fisher update`
7. Node: `fnm install --lts && fnm default lts-latest`; enable corepack for pnpm: `corepack enable`
8. tmux: just start it — tpm and plugins auto-install
9. Yazi: `ya pkg install`
10. Agent skills: install manually (see README, `npx skills add ...`)
11. Import Raycast settings, sign into browsers/Slack/Spotify/etc.

## Post-migration cleanup

- [ ] Reconcile Brewfile drift: `brew bundle check --global --verbose`
