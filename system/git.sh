# Git aliases
alias git=hub

alias gpull="git pull --rebase"
alias gpush="git push origin HEAD"
alias gstashedpull="git stash && git pull --rebase && git stash pop"

info () {
  printf "\033[00;34m$1\033[0m\n"
}

grbranch () {
  git status -sb | sed -En 's/^## [a-zA-Z1-9\-_]+\.\.\.([a-zA-Z1-9\-_]+\/[a-zA-Z1-9\-_]+).*$/\1/p'
} 

grlog () {
  git fetch

  local remote_current_branch=`grbranch`

  info "*** Incoming commits"
  info "***********************************************"
 
  git log ..$remote_current_branch | cat 

  info "*** Outgoing commits"
  info "***********************************************"
  git log $remote_current_branch.. | cat
}

alias gcommit="git commit -m"
alias gaddall="git add --all"
alias gdiff="git diff"
alias ghead="cat .git/HEAD" # TODO: would be cool to make this recursively
alias gammit="gaddall && gcommit"
# alias gapush="gammit $1 &&  gpush"

alias gustash="git stash save --include-untracked"
alias glstash="git stash list | cat"
# alias gpstash="git stash pop"

alias glasthash='git log -n 1 --pretty=format:"%H" | ccopy &&  echo `git log -n 1 --pretty=format:"%H"`'
alias glastdiff="git diff HEAD~1 HEAD"
alias glean="git checkout -- . && git clean -f -d"
alias gtagls="git tag | gsort -V"
alias gcontainscommit="git branch -r --contains"

alias gsubpull="git submodule foreach git pull origin HEAD"

