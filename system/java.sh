# java home related
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
function setjavahome() {
	export JAVA_HOME=`/usr/libexec/java_home -v $1`
}

alias java7="setjavahome 1.7"
alias java8="setjavahome 1.8"

