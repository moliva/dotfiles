
alert() {
	osascript -e 'display notification "Studio has finished building :)" with title "Built finished!"'
}

clastcommand() {
	local lastcommand=$(fc -ln -1)
        echo $lastcommand | ccopy
	echo "\"$lastcommand\" copied to clipboard!"
}
