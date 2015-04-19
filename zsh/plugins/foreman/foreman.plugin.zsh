# GitHub Gist danmartens / foreman.plugin.zsh
fs() {
  if (( $# == 1 )); then
    cd ~/Projects/$1;
  fi
 
  if ls 'Procfile.local' &> /dev/null; then
    local procfile='Procfile.local'
    echo "Starting foreman with Procfile.local...";
  else
    local procfile='Procfile'
    echo "Starting foreman with Procfile...";
  fi
 
  foreman start -f $procfile;
}
 
_fs() { _files -W ~/Projects -/; }
compdef _fs fs
 
alias fs='nocorrect fs'
