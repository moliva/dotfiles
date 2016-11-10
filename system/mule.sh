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

# export MULE_HOME=/Applications/mule-enterprise-standalone-3.3.2

