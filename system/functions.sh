# From https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
# Open man page as PDF
function manpdf() {
 man -t "${1}" | open -f -a /Applications/Preview.app/
}
# Extra many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
function extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2) tar -jxvf $1 ;;
      *.tar.gz) tar -zxvf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.dmg) hdiutil mount $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar -xvf $1 ;;
      *.tbz2) tar -jxvf $1 ;;
      *.tgz) tar -zxvf $1 ;;
      *.zip) unzip $1 ;;
      *.ZIP) unzip $1 ;;
      *.pax) cat $1 | pax -r ;;
      *.pax.Z) uncompress $1 —stdout | pax -r ;;
      *.Z) uncompress $1 ;;
      *) echo "'$1' cannot be extracted/mounted via extract()";;
   esac
 else
   echo "'$1' is not a valid file to extract"
 fi
}

function findfileswith() {
	find . -name $1 -print | xargs grep $2
}

# autoload function for help
autoload run-help

function clastcommand() {
	local lastcommand=$(fc -ln -1)
        echo "$lastcommand" | ccopy
	echo "\"$lastcommand\" copied to clipboard!"
}

function listcolors() {
	for i in {0..255} ; do    
		printf "[38;5;${i}mcolour${i}\n"
	done
}
