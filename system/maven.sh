#!/usr/bin/env zsh

export M2_SETTINGS=$HOME/.m2
export M2_REPO=$M2_SETTINGS/repository

export MAVEN_OPTS="-Xmx1G -XX:MaxPermSize=512m -Djava.awt.headless=true"

alias mvnsettings="edit $M2_SETTINGS/settings.xml"

linkmaven() {
	local current_maven_formula=$(basename $(dirname $(dirname `mvn --version | sed '/^Maven home: /!d' | sed "s/^Maven home: \(.*\)/\1/"`))) # two dirnames for libexec and version
	brew unlink $current_maven_formula
	brew link $1
}
