if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim
set -gx PATH $PATH $HOME/.bin
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
set -gx HOMEBREW_SHELLENV_PREFIX /opt/homebrew
set -gx MANPATH /opt/homebrew/share/man $MANPATH
set -gx INFOPATH $INFOPATH /opt/homebrew/share/info

set -gx BAT_THEME "gruvbox-dark"
set -gx PNPM_HOME "/Users/javivelasco/Library/pnpm"
set -gx GOPATH "/Users/javivelasco/.go"

set -gx PATH $PATH /opt/homebrew/bin /opt/homebrew/sbin
set -gx PATH $PATH /opt/homebrew/opt/kubernetes-cli@1.22/bin
set -gx PATH $PATH $(go env GOPATH)/bin
set -gx PATH $PATH $PNPM_HOME
set -gx PATH $PATH $HOME/.cargo/bin

set fish_greeting ""

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias dl="cd ~/Downloads"
alias g="git"
alias h="history"

if ls --color > /dev/null 2>&1
    set colorflag "--color"
else # OS X `ls`
    set colorflag "-G"
end

# List all files colorized in long format
alias l="ls -lF $colorflag"

# List all files colorized in long format, including dot files
alias la="ls -laF $colorflag"

# # List only directories
alias lsd="ls -lF $colorflag | grep --color=never '^d'"

# # Always use color output for `ls`
alias ls="command ls $colorflag"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Disable/Enable Spotlight
alias spotoff="sudo mdutil -a -i off"
alias spoton="sudo mdutil -a -i on"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# # Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# A shorcut for kubectl
alias k=kubectl

# Default to neovim
alias vim=nvim
alias vi=nvim

# Get header details in stderr so the output can be piped
alias curld="curl -sD /dev/stderr"

alias deploy-single-file="~/Code/deploy-single-file/bin/deploy-single-file"

# Setup nvm
set --universal nvm_default_version v16.13.0 

# Load secret config
set FISH_SECRET_CONFIG_PATH (dirname (status --current-filename))/config-secret.fish
if test -f $FISH_SECRET_CONFIG_PATH
  source $FISH_SECRET_CONFIG_PATH
end

