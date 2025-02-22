#!/usr/bin/env zsh

# adding path directory for custom scripts
# TODO - move to a function - moliva - 2025/01/03
new_paths=(/usr/bin /bin /usr/sbin /sbin $HOME/bin $HOME/.git-utils/bin $HOME/.cargo/bin $WASMTIME_HOME/bin $HOME/.local/share/solana/install/active_release/bin $HOME/.local/bin)
path=($path ${new_paths:|path})
new_paths=

export REPOS="$HOME/repos"

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# docker
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

export DOCKER_HOME_REGISTRY=raspberrypi.manatee-royal.ts.net:5000

# clean and re install node modules
alias npmrefresh="rm -fr node_modules && npm i"

function ya() {
  tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

alias resetgpg="killall gpg-agent || gpg-agent --daemon --use-standard-socket --pinentry-program /opt/homebrew/bin/pinentry-mac &"

# In order for gpg to find gpg-agent, gpg-agent must be running, and there must be an env
# variable pointing GPG to the gpg-agent socket. This little script, which must be sourced
# in your shell's init script (ie, .bash_profile, .zshrc, whatever), will either start
# gpg-agent or set up the GPG_AGENT_INFO variable if it's already running.

# Add the following to your shell init to set up gpg-agent automatically for every shell
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info 2> /dev/null)
fi


# pnpm
export PNPM_HOME="/Users/moliva/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


ulimit -n 2048



# *************************************************************
# common-aliases
# *************************************************************

alias zshconfig="edit ~/.zshrc"
alias zshreload='source ~/.zshrc'

alias localconfig="edit ~/.localrc"
alias localreload='source ~/.localrc'

function systemconfig() {
	edit $DOTFILES/system
}

function systemreload() {
	for config ($DOTFILES/system/**/*.zsh) source $config
}


# copies the input to clipboard, best used as pipeline in cmd shell
#alias -g ccopy="tr -d '\n' | pbcopy"
function ccopy() {
	tr -d '\n' | pbcopy
}

alias lgrep="l | grep $1"
alias cpwd="pwd | ccopy"

# force miguel to use nvim instead of vim
alias vimo=/usr/bin/vim
alias vim=nvim
# alias vim=$HOME/nvim-macos-arm64/bin/nvim
# alias nvim=$HOME/nvim-macos-arm64/bin/nvim


alias loadzgenom="source $DOTFILES/zgen/zgenom.zsh"

alias l='ls -l -a -h'
alias ls='eza --icons=auto'
alias ll=l
alias tree='eza --tree'
alias bat='bat --theme=base16'
# alias cat='bat --paging=never'
alias cat='bat -p --theme=base16'
alias batp='bat --paging=always --theme=base16'

#alias ps=procs
#alias nano=kibi
#alias find=fd
alias duh=dust
alias timeh=hyperfine
#alias top=ytop
#alias iftop=bandwhich
#alias hexdump=hx
#alias objdump=bringrep
#alias http-server=miniserve
#alias license=licensor
#alias -g grep=rg

alias grepo=/usr/bin/grep

# *************************************************************
# climode
# *************************************************************

function zle-line-init zle-keymap-select {
	VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
	RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$EPS1"
	zle reset-prompt
}

vistatus() {
	zle -N zle-line-init
	zle -N zle-keymap-select
}

# set -o vi
bindkey -v

#export KEYTIMEOUT=1
export KEYTIMEOUT=40 # needed to change this value to sth greater than before

bindkey -M vicmd "^R" history-incremental-search-backward
bindkey -M viins "^R" history-incremental-search-backward

bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward
# bindkey -M vicmd "/" vi-history-search-backward
# bindkey -M vicmd "?" vi-history-search-forward
bindkey -M vicmd "n" vi-repeat-search
bindkey -M vicmd "N" vi-rev-repeat-search

bindkey -M vicmd "^P" history-beginning-search-backward
bindkey -M vicmd "^N" history-beginning-search-forward

# trying if this fixes the issue when backspacing chars after normal mode
bindkey "^?" backward-delete-char

# complete with suggestion
bindkey '^j' autosuggest-accept


# *************************************************************
# fzf
# *************************************************************

# this overrides bindings above
source <(fzf --zsh)

export FZF_TMUX_OPTS=" -p90%,70% "



# *************************************************************
# env
# *************************************************************

#export ZGEN_PREZTO_LOAD_DEFAULT=0

# Make vim the default editor.
if [[ -z $EDITOR ]]; then
	export EDITOR='nvim'
fi

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Always enable colored `grep` output.
export GREP_OPTIONS='--color=auto'

# Setting help dir to the new zsh
export HELPDIR=/usr/local/share/zsh/help


# *************************************************************
# functions
# *************************************************************

# fpath=($DOTFILES/system/functions $fpath)
# for function_file ($DOTFILES/system/functions/*) autoload $(basename $function_file)

b64s() {
	echo -n $1 | base64 | ccopy
}

# Given a variable set of arguments:
#   mvp file1 file2 ... dir
# Makes sure the `dir` exists and moves every other file to it
mvp() {
	last=$@[$#]
	mkdir -p "$last"
	mv "$@"
}

# Extra many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
function extract() {
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2) tar -jxvf $1 ;;
			*.tar.gz) tar -zxvf $1 ;;
			*.bz2) bunzip2 $1 ;;
			*.dmg) hdiutil mount $1 ;;
			*.gz) gunzip $1 ;;
			*.tar) tar -xvf $1 ;;
			*.tbz2) tar -jxvf $1 ;;
			*.tgz) tar -zxvf $1 ;;
			*.zip) unzip $1 ;;
			*.ZIP) unzip $1 ;;
			*.pax) cat $1 | pax -r ;;
			*.pax.Z) uncompress $1 —stdout | pax -r ;;
			*.Z) uncompress $1 ;;
			*) echo "'$1' cannot be extracted/mounted via extract()";;
		esac
	else
		echo "'$1' is not a valid file to extract"
	fi
}

# autoload function for help
autoload run-help

function clastcommand() {
	local lastcommand=$(fc -ln -1)

	echo "$lastcommand" | ccopy
	echo "\"$lastcommand\" copied to clipboard!"
}

function listcolors() {
	for i in {0..255} ; do
		printf "[38;5;${i}mcolour${i}\n"
	done
}

function ssh-up() {
	# ensure ssh agent is up and ssh keys are added so that git doesn't bother
	eval $(ssh-agent)
	ssh-add
}

function cpmod() {
	chmod `stat -f %A $1` $2
}


# *************************************************************
# git
# *************************************************************

alias gpush="git spush"
alias gpull="git spull"

gprune() {
  git fetch --prune
}

groot() {
  cd `git rev-parse --show-toplevel`
}

# grbranch () {
#   git status -sb | sed -en 's/^## [a-za-z1-9\-_]+\.\.\.([a-za-z1-9\-_]+\/[a-za-z1-9\-_]+).*$/\1/p'
# } 

# info () {
#   printf "\033[00;34m$1\033[0m\n"
# }

# grlog () {
#   git fetch
# 
#   local remote_current_branch=`grbranch`
# 
#   info "*** incoming commits"
#   info "***********************************************"
#  
#   git log ..$remote_current_branch | cat 
# 
#   info "*** outgoing commits"
#   info "***********************************************"
#   git log $remote_current_branch.. | cat
# }

alias guppush='git push moliva HEAD'
function gupcreateremote() {
  local repo_name=$(basename `git rev-parse --show-toplevel`)
  git remote add moliva "https://github.com/moliva/$repo_name"
}

# use fzf-git to checkout an existing branch
function fco() {
  branch=$(_fzf_git_branches)
  if [ -n "$branch" ]; then
    git checkout $branch
  fi
}

# clone a repo in bare mode to work with worktrees into a dir with the corresponding name
function gwclone() {
  name=$(basename "$1" | sed 's/\.[^.]*$//')

  git clone --bare "$1" "$name"
}

alias gmlog="git log --author=`git config user.name`"

gcommit () {
	git commit -S -m "`echo $@`"
}

gncommit () {
	git commit -S -n -m "`echo $@`"
}

alias gaddall="git add --all"
alias gdiff="git diff"
alias ghead="cat .git/head" # todo: would be cool to make this recursively
alias gammit="gaddall && gcommit"
# alias gapush="gammit $1 &&  gpush"
alias gan="git add -n"

alias gustash="git stash save --include-untracked"
alias glstash="git stash list | cat"
# alias gpstash="git stash pop"

alias gopen="gh browse"

alias glasthash="git last-hash"
alias glastdiff="git diff head~1 head"
alias glean="git checkout -- . && git clean -f -d"
alias gtagls="git tag | gsort -v"
alias gcontainscommit="git branch -r --contains"

alias gsubpull="git submodule foreach git pull origin head"

# gsetremotebranch() {
# 	local_branch=$(git branch | grep \* | cut -d ' ' -f2)
# 	git branch --set-upstream-to="origin/$local_branch" "$local_branch"
# }
# 
# ggetremotebranch() {
# 	git branch -vv | grep \*
# }

alias gdiffstash=git diff stash@{0}

alias gr='git review'
alias gru='git review -u'

# *************************************************************
# go
# *************************************************************

# go lang related
export GOPATH=$HOME/go

# TODO - write output of eval to some env in home and load conditionally
#GO_INSTALLATION=_evalcache brew --prefix go
#export PATH=$PATH:$GO_INSTALLATION/libexec/bin:$GOPATH/bin
#export PATH=$PATH:`brew --prefix go`/libexec/bin:$GOPATH/bin
# export PATH=$PATH:/usr/local/opt/go/libexec/bin:$GOPATH/bin

# *************************************************************
# groovy
# *************************************************************

# TODO - write output of eval to some env in home and load conditionally
#GROOVY_INSTALLATION={ _evalcache brew --prefix groovy }
#export GROOVY_HOME=$GROOVY_INSTALLATION/libexec
#export GROOVY_HOME=`brew --prefix groovy`/libexec
# export GROOVY_HOME=/usr/local/Cellar/groovy/3.0.7/libexec

# *************************************************************
# java
# *************************************************************

# java home related
#export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
#function setjavahome() {
	# export JAVA_HOME=`/usr/libexec/java_home -v $1`
#}

#alias java7="setjavahome 1.7"
#alias java8="setjavahome 1.8"

# *************************************************************
# zoxide
# *************************************************************

_evalcache zoxide init zsh

# *************************************************************
# fnm
# *************************************************************

_evalcache  fnm env --use-on-cd --shell zsh --corepack-enabled --resolve-engines

# *************************************************************
# python
# *************************************************************
export PATH=$PATH:$HOME/Library/Python/3.7/bin
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

loadpyenv() {
	#eval "$(pyenv init -)"
	_evalcache pyenv init -
	#eval "$(pyenv virtualenv-init -)" # takes a HUGE amount of time
}

# Add every binary that requires nvm, npm or node to run to an array of node globals
PYENV_COMMANDS=("pyenv")

# Making node global trigger the lazy loading
for cmd in "${PYENV_COMMANDS[@]}"; do
  eval "${cmd}(){ unset -f ${PYENV_COMMANDS}; loadpyenv; ${cmd} \$@ }"
done


# *************************************************************
# rust
# *************************************************************

# source $HOME/.cargo/env
# ˆ inlining above mentioned source
# export PATH="$HOME/.cargo/bin:$PATH"

# export RUSTC_WRAPPER=sccache
. "$HOME/.cargo/env"

# *************************************************************
# tmux
# *************************************************************

[ -z "$TMUX" ] && export TERM=xterm-256color

alias tmuxconfig="edit $HOME/.tmux.conf"
alias tmuxkill="tmux kill-session -t"

# *************************************************************
# starship
# *************************************************************

_evalcache starship init zsh

# zsh-autocompletions

ZSH_AUTOSUGGEST_IGNORE_WIDGETS="vi-change vi-delete $ZSH_AUTOSUGGEST_IGNORE_WIDGETS"


# enable vim-surround mode in zsh
bindkey -v
autoload -U select-quoted select-bracketed surround
zle -N select-quoted
zle -N select-bracketed
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

# *************************************************************
# *********** WASMTIME *************
# *************************************************************

export WASMTIME_HOME="$HOME/.wasmtime"

# export PATH="$WASMTIME_HOME/bin:$PATH"


# *****************************************************************************************************
# *************** utils ***************
# *****************************************************************************************************

# fuzzy find query in files in the current dir and open them in nvim
rfind() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            nvim {1} +{2}     # No selection. Open the current line in Vim.
          else
            nvim +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)


function pd() {
  wd=$(phantom-dev)
  
  if [ "$wd" != "" ]; then
    cd $wd
  fi
}

function pd2() {
  wd=$(phantom-dev-v2 "$@")
  
  if [ "$wd" != "" ]; then
    cd $wd
  fi
}
