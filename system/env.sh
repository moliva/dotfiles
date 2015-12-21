#!/usr/bin/env zsh

# Make vim the default editor.
if [[ -z $EDITOR ]]; then
	export EDITOR='vim'
fi

# Set env for workspace
export WS_HOME=$HOME/repos

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Always enable colored `grep` output.
export GREP_OPTIONS='--color=auto'

# Setting help dir to the new zsh
export HELPDIR=/usr/local/share/zsh/help

# adding basic bin directories to PATH
# TODO: is this necessary?
new_paths=(/usr/local/bin /usr/bin /bin /usr/sbin /sbin)
path=($path ${new_paths:|path})
new_paths=

# openssl
#export OpenSSL_HOME=$HOME/bin/openssl-1.0.1e
#export AWS_IAM_HOME=$HOME/bin/IAMCli-1.5.0

#new_paths=($OpenSSL_HOME/bin $AWS_IAM_HOME/bin)
#path=($path ${new_paths:|path})
#new_paths=

# sublime text command
#local new_paths=(/Applications/Sublime\ Text.app/Contents/SharedSupport/bin)
#path=($path ${new_path:|path})

# light table editor
#local new_paths=(/Applications/LightTable.app/Contents)
#path=($path ${new_path:|path})
