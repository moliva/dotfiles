# Example aliases
alias zshconfig="vim ~/.zshrc"
alias zshreload='source ~/.zshrc'

alias l='ls -l -a -h'

# copies the input to clipboard, best used as pipeline in cmd shell
alias ccopy="tr -d '\n' | pbcopy"
alias lgrep="l | grep $1"
alias cpwd="pwd | ccopy"

