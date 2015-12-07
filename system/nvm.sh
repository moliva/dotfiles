# nvm aliases
export NVM_DIR=$HOME/.nvm

function loadnvm() {
	source $(brew --prefix nvm)/nvm.sh
	nvm use stable
}
