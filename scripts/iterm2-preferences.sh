#!/usr/bin/env bash
# script modified from https://github.com/fnichol/macosx-iterm2-settings

set -e

plist="com.googlecode.iterm2.plist"

plist_path="$DOTFILES/iterm2/$plist"
installed_plist="$HOME/Library/Preferences/$plist"

log()   { printf -- "-----> $*\n" ; return $? ; }
warn()  { printf -- ">>>>>> $*\n" ; return $? ; }

if ! command -v curl >/dev/null ; then
  printf "\n>>>> Could not find curl on your PATH so quitting.\n"
  exit 2
fi

if [[ "$TERM_PROGRAM" == "iTerm.app" ]] ; then
  warn "You appear to be running this script from within iTerm.app which could"
  warn "overwrite your new preferences on quit.\n"
  warn "Please quit iTerm and run this from Terminal.app or an SSH session.\n"
  exit 3
fi

if ps wwwaux | egrep -q 'iTerm\.app' >/dev/null ; then
  warn "You appear to have iTerm.app currently running. Please quit the"
  warn "application so your updates won't get overridden on quit.\n"
  exit 4
fi

if [[ $? -eq 0 ]] ; then
  cp -f "$plist_path" "$installed_plist"
  defaults read com.googlecode.iterm2
  log "iTerm preferences installed/updated in $installed_plist"
else
  warn "The download or conversion from XML to binary failed. Your current"
  warn "preferences have not been changed.\n"
  exit 5
fi

exit $?
