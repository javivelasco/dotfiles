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

# | autosuggestions | #
zplugin ice wait"0" atload"_zsh_autosuggest_start" lucid
zplugin light zsh-users/zsh-autosuggestions

# search history via substring
zplugin light zsh-users/zsh-history-substring-search 

# search through long list of commands with Ctrl+R
zplugin ice from"gh" wait"1" silent pick"history-search-multi-word.plugin.zsh" lucid
zplugin light zdharma/history-search-multi-word

zplugin ice from"gh" wait"1" atinit"zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting
