# Example aliases
alias zshconfig="edit ~/.zshrc"
alias zshreload='source ~/.zshrc'

alias vimconfig="edit ~/.vimrc"

alias l='ls -l -a -h'

# copies the input to clipboard, best used as pipeline in cmd shell
alias ccopy="tr -d '\n' | pbcopy"
alias lgrep="l | grep $1"
alias cpwd="pwd | ccopy"

