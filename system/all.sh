#!/usr/bin/env zsh

# *************************************************************
# common-aliases
# *************************************************************

# Example aliases
alias zshconfig="edit ~/.zshrc"
alias zshreload='source ~/.zshrc'

alias localconfig="edit ~/.localrc"
alias localreload='source ~/.localrc'

alias vimconfig="edit ~/.vimrc"

alias l='ls -l -a -h'

# copies the input to clipboard, best used as pipeline in cmd shell
alias ccopy="tr -d '\n' | pbcopy"
alias lgrep="l | grep $1"
alias cpwd="pwd | ccopy"

# force miguel to use nvim instead of vim
alias vimo=/usr/bin/vim
alias vim=nvim

systemconfig() {
	edit $DOTFILES/system
}

alias loadzgenom="source $DOTFILES/zgen/zgenom.zsh"

alias ls=exa
alias cat='bat --paging=never'
alias batp='bat --paging==always'

#alias ps=procs alias cat=bat alias less=bat alias grep=ripgrep
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

export KEYTIMEOUT=1

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

# this overrides bindings above
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh




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

# adding basic bin directories to PATH
# TODO: is this necessary?
new_paths=(/usr/local/bin /usr/bin /bin /usr/sbin /sbin $HOME/bin)
path=($path ${new_paths:|path})
new_paths=


# *************************************************************
# fasd
# *************************************************************

_evalcache fasd --init auto
alias v="a -e edit" 
alias e="a -e"

# *************************************************************
# functions
# *************************************************************

# fpath=($DOTFILES/system/functions $fpath)
# for function_file ($DOTFILES/system/functions/*) autoload $(basename $function_file)

b64s() {
	echo -n $1 | base64 | ccopy
}

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

function systemreload() {
	for config ($DOTFILES/system/**/*.sh) source $config
}

# *************************************************************
# git
# *************************************************************

# git aliases
alias git=hub

alias gpush="git push -u origin head"

gpull() {
  git diff --exit-code --quiet 1> /dev/null
  any_diff="$?"
  if [ "$any_diff" -ne "0" ]; then
    git stash
  fi
  git pull --rebase
  if [ "$any_diff" -ne "0" ]; then
    git stash pop
  fi
  gprune
}

gprune() {
  git fetch --prune
}

gtoprepo() {
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

alias gmlog="git log --author=`git config user.name`"

gcommit () {
	git commit -m "`echo $@`"
}

gncommit () {
	git commit -n -m "`echo $@`"
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

alias glasthash='git log -n 1 --pretty=format:"%h" | ccopy &&  echo `git log -n 1 --pretty=format:"%an - %s - %h"`'
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
# 

# *************************************************************
# go
# *************************************************************

# go lang related
export GOPATH=$HOME/go

# TODO - write output of eval to some env in home and load conditionally
#GO_INSTALLATION=_evalcache brew --prefix go
#export PATH=$PATH:$GO_INSTALLATION/libexec/bin:$GOPATH/bin
#export PATH=$PATH:`brew --prefix go`/libexec/bin:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin:$GOPATH/bin

# *************************************************************
# groovy
# *************************************************************

# TODO - write output of eval to some env in home and load conditionally
#GROOVY_INSTALLATION={ _evalcache brew --prefix groovy }
#export GROOVY_HOME=$GROOVY_INSTALLATION/libexec
#export GROOVY_HOME=`brew --prefix groovy`/libexec
export GROOVY_HOME=/usr/local/Cellar/groovy/3.0.7/libexec

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
# nvm
# *************************************************************

# nvm aliases
export NVM_DIR=$HOME/.nvm

# Lazy-loading nvm + npm on node globals call
function load_nvm () {
  [ -s "usr/local/opt/nvm/nvm.sh" ] && source "usr/local/opt/nvm/nvm.sh"
  #[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"
}

enable_smart_load_nvm() {
	NODE_GLOBALS_CACHED=$HOME/.node_globals_cache
	
	if [ ! -f "$NODE_GLOBALS_CACHED" ]; then
		find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq > "$NODE_GLOBALS_CACHED"
	fi
	
	# Add every binary that requires nvm, npm or node to run to an array of node globals
	NODE_GLOBALS=(`cat "$NODE_GLOBALS_CACHED"`)
	NODE_GLOBALS+=("node")
	NODE_GLOBALS+=("nvm")
	
	# Making node global trigger the lazy loading
	for cmd in "${NODE_GLOBALS[@]}"; do
	  eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
	done
}


# *************************************************************
# python
# *************************************************************
export PATH=$PATH:$HOME/Library/Python/3.7/bin

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
export PATH="$HOME/.cargo/bin:$PATH"

# *************************************************************
# tmux
# *************************************************************

[ -z "$TMUX" ] && export TERM=xterm-256color

alias tmuxconfig="edit $HOME/.tmux.conf"
alias tmuxkill="tmux kill-session -t"

