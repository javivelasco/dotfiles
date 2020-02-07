### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

PS1=""
autoload colors; colors
setopt promptsubst

##### Load aliases, exports and profiles
for file in ~/.{aliases,exports,functions,secrets}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

##### Plugins
zinit ice wait'!' lucid
zinit light jackharrisonsherlock/common

zinit ice wait lucid
zinit snippet OMZ::lib/git.zsh

zinit ice wait atload"unalias grv" lucid
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/kubectl/kubectl.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

zinit ice wait as"completion" lucid
zinit snippet OMZ::plugins/docker/_docker

zinit ice wait atinit"zpcompinit" lucid
zinit light zdharma/fast-syntax-highlighting

zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

##### FZF Setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/javivelasco/Code/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/javivelasco/Code/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/javivelasco/Code/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/javivelasco/Code/google-cloud-sdk/completion.zsh.inc'; fi
