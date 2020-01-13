
function zle-line-init zle-keymap-select {
	VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
	RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$EPS1"
	zle reset-prompt
}

vistatus() {
	zle -N zle-line-init
	zle -N zle-keymap-select
}

vimode() {
	# set -o vi
	bindkey -v

	export KEYTIMEOUT=1

	bindkey -M vicmd "^R" history-incremental-search-backward
	bindkey -M viins "^R" history-incremental-search-backward

	bindkey -M vicmd "/" history-incremental-search-backward
	bindkey -M vicmd "?" history-incremental-search-forward
	# bindkey -M vicmd "/" vi-history-search-backward
	# bindkey -M vicmd "?" vi-history-search-forward
	bindkey -M vicmd "n" vi-repeat-search
	bindkey -M vicmd "N" vi-rev-repeat-search

	bindkey -M vicmd "^P" history-beginning-search-backward
	bindkey -M vicmd "^N" history-beginning-search-forward

	# trying if this fixes the issue when backspacing chars after normal mode
	bindkey "^?" backward-delete-char
}

vimode

