export DOTFILES=$HOME/.dotfiles

# zsh related env
export ZSH=$DOTFILES/zsh
export ZSH_PLUGINS=$ZSH/plugins

# load zgen
source $DOTFILES/zgen/zgen.zsh

source $HOME/.profile

export EDITOR='vim'

#unalias run-help
autoload run-help
export HELPDIR=/usr/local/share/zsh/help

# adding path directory for custom scripts
export PATH=$DOTFILES/bin:$PATH

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins from oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/mvn
    zgen oh-my-zsh plugins/bower
    zgen oh-my-zsh plugins/heroku
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/grunt
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/sbt
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/cabal
    zgen oh-my-zsh plugins/lein

    # other plugins
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load tmuxinator/tmuxinator

    # local plugins
    zgen load $ZSH_PLUGINS/ttool
    zgen load $ZSH_PLUGINS/jiraffe
    zgen load $ZSH_PLUGINS/mvn
    zgen load $ZSH_PLUGINS/setmulehome
    zgen load $ZSH_PLUGINS/foreman

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen oh-my-zsh themes/robbyrussell

    # save all to init script
    zgen save
fi

# Example aliases
alias zshconfig="vim ~/.zshrc"
alias zshreload='source ~/.zshrc'

alias l='ls -l -a -h'

# copies the input to clipboard, best used as pipeline in cmd shell
alias ccopy="tr -d '\n' | pbcopy"
alias lgrep="l | grep $1"
alias cpwd="pwd | ccopy"

# Git aliases
alias gpull="git pull --rebase"
alias gpush="git push origin HEAD"
alias gstashedpull="git stash; git pull --rebase; git stash pop"
alias gclone="git clone"
alias gcommit="git commit -m"
alias gaddall="git add --all"
alias gdiff="git diff"
alias ghead="cat .git/HEAD" # Estaria copado hacer que suba en el arbol hasta encontrar el primer .git
alias gammit="gaddall; gcommit"
alias gapush="gammit $1; gpush"
alias gfcheckout="git checkout -f"
alias gustash="git stash save --include-untracked"
alias glstash="git stash list | cat"
alias gpstash="git stash pop"
alias glasthash='git log -n 1 --pretty=format:"%H" | ccopy | echo `git log -n 1 --pretty=format:"%H"`'
alias glastdiff="git diff HEAD~1 HEAD"

# Base16 Shell
# if [ -z "$THEME" ]; then
    export THEME="base16-harmonic16"
# fi
if [ -z "$BACKGROUND" ]; then
    export BACKGROUND="dark"
fi

export BASE16_SHELL="$DOTFILES/.config/base16-shell/$THEME.$BACKGROUND.sh"
# [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
source $BASE16_SHELL

# Mule aliases
alias mule='$MULE_HOME/bin/mule'
alias devmule='mule -M-Dmule.env=dev'
alias prodmule='mule -M-Dmule.env=prod'
alias cleanmule='rm -rf $MULE_HOME/apps/*'
alias listmuleapps='l $MULE_HOME/apps'
alias cleananchors='rm -rf $MULE_HOME/apps/*-anchor.txt'

function setmulehome() {
	export MULE_HOME="/Applications/mule-enterprise-standalone-"$1
}

function installmuleapp() {
	cp $1 $MULE_HOME/apps
}

export MULE_HOME=/Applications/mule-enterprise-standalone-3.3.2
export MULE_TOOLING="$WS_HOME/Mule-Tooling"

# tmuxifier setup
[[ -s "$HOME/.tmuxifier/init.sh" ]] && source "$HOME/.tmuxifier/init.sh"

# java home related
export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
function setjavahome() {
	export JAVA_HOME=`/usr/libexec/java_home -v $1`
}

alias java7="setjavahome 1.7"
alias java8="setjavahome 1.8"

# go lang related
export GOPATH=$HOME/go

export WS_HOME="$HOME/Workspace"
export Q7_WS_HOME="$HOME/q7workspace"

# maven related
export M2_HOME=/usr/local/Cellar/maven/3.2.2/libexec
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xmx1G -XX:MaxPermSize=512m -Djava.awt.headless=true"


export CATALINA_HOME=/Applications/apache-tomcat-7.0.42

# hadoop
export HADOOP_HOME=/usr/local/Cellar/hadoop/2.5.2
export HADOOP_CONF=$HADOOP_HOME/libexec/etc/hadoop

export DRIVEN_API_KEY=2B95A0E44072465A83023317714172B9

export SPARK_HOME=$HOME/Downloads/spark-1.2.1-bin-hadoop2.4

export PATH=/usr/local/Cellar/vim/7.4.488/bin/:/Applications/LightTable.app/Contents:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:/Applications/activator-1.2.10:$M2:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:$HOME/bin:$CATALINA_HOME/bin:/usr/local/Cellar/ruby/2.0.0-p247/bin:$PATH

export OpenSSL_HOME=$HOME/bin/openssl-1.0.1e
export AWS_IAM_HOME=$HOME/bin/IAMCli-1.5.0

export PATH=$OpenSSL_HOME/bin:$AWS_IAM_HOME/bin:$PATH

function findfileswith() {
	find . -name $1 -print | xargs grep $2
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f /Users/miguel/.travis/travis.sh ] && source /Users/miguel/.travis/travis.sh

# Studio aliases
export STUDIO_EXEC_NAME=AnypointStudio
export STUDIO_BUILD_PATH=$MULE_TOOLING/org.mule.tooling.products/org.mule.tooling.studio.product/target/products/studio.product/macosx/cocoa/x86_64/AnypointStudio

export OPEN_STUDIO_EXEC_PATH=$STUDIO_BUILD_PATH/$STUDIO_EXEC_NAME
alias openstudio="open $STUDIO_BUILD_PATH/$STUDIO_EXEC_NAME"
alias setdebugforstudio="echo '-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005\n' >> $STUDIO_BUILD_PATH/$STUDIO_EXEC_NAME.app/Contents/MacOS/$STUDIO_EXEC_NAME.ini"

# Vim related
function installvimplugin() {
	local current=`pwd`
	cd $HOME/.vim/bundle
	git clone $1
	cd $current
}

# docker
export DOCKER_HOST=tcp://192.168.59.103:2375

[ -z "$TMUX" ] && export TERM=xterm-256color
