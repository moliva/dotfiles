#!/usr/bin/env zsh
# maven related

if [ -z "$M2_HOME" ]; then
	export M2_HOME=$(brew --prefix maven)/libexec
fi

export M2_SETTINGS=$HOME/.m2
export M2_REPO=$M2_SETTINGS/repository

export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xmx1G -XX:MaxPermSize=512m -Djava.awt.headless=true"

export PATH=$M2:$PATH

alias mvnsettings="edit $M2_SETTINGS/settings.xml"

# TODO: write functions to change easily between brew-managed maven versions
