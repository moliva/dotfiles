# Make vim the default editor.
export EDITOR='vim';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Always enable colored `grep` output.
export GREP_OPTIONS='--color=auto';

# Setting help dir to the new zsh
export HELPDIR=/usr/local/share/zsh/help

# other exports
# TODO: try to clean the PATH var assignation somehow
export CATALINA_HOME=/Applications/apache-tomcat-7.0.42

# hadoop
export HADOOP_HOME=/usr/local/Cellar/hadoop/2.5.2
export HADOOP_CONF=$HADOOP_HOME/libexec/etc/hadoop

export SPARK_HOME=$HOME/Downloads/spark-1.2.1-bin-hadoop2.4

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/Cellar/vim/7.4.488/bin/:/Applications/LightTable.app/Contents:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:/Applications/activator-1.2.10:/sbin:/usr/local/git/bin:$HOME/bin:$CATALINA_HOME/bin:/usr/local/Cellar/ruby/2.0.0-p247/bin:$PATH

export OpenSSL_HOME=$HOME/bin/openssl-1.0.1e
export AWS_IAM_HOME=$HOME/bin/IAMCli-1.5.0

export PATH=$OpenSSL_HOME/bin:$AWS_IAM_HOME/bin:$PATH

