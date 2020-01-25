### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

PS1=""
autoload colors; colors
setopt promptsubst

##### Load aliases, exports and profiles
for file in ~/.{aliases,exports,functions,secrets}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

##### Plugins
zplugin ice wait'!' lucid
zplugin light jackharrisonsherlock/common

zplugin ice wait lucid
zplugin snippet OMZ::lib/git.zsh

zplugin ice wait atload"unalias grv" lucid
zplugin snippet OMZ::plugins/git/git.plugin.zsh

zplugin ice wait lucid
zplugin snippet OMZ::plugins/kubectl/kubectl.plugin.zsh

zplugin ice wait lucid
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

zplugin ice wait as"completion" lucid
zplugin snippet OMZ::plugins/docker/_docker

zplugin ice wait atinit"zpcompinit" lucid
zplugin light zdharma/fast-syntax-highlighting

zplugin ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zplugin light trapd00r/LS_COLORS

zplugin ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zplugin light sharkdp/bat

##### FZF Setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/javivelasco/Code/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/javivelasco/Code/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/javivelasco/Code/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/javivelasco/Code/google-cloud-sdk/completion.zsh.inc'; fi
