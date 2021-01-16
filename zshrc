#################################################
# ALIAS
alias ll="ls -la"

#################################################
# Prefer our version pf Python over the MAC ver
export PATH="/usr/local/bin:$PATH"

#################################################
# Virtual Environments
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
source /usr/local/bin/virtualenvwrapper.sh
export VIRTUALENV_PYTHON="/usr/local/bin/python3"

#################################################
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

#################################################
# Add Go
export PATH="$PATH:/usr/local/go/bin"

#################################################
# Override mkvirtualenv
mkvirtualenv() {
    if [ -z "$1" ]
    then
    	@echo "You need to supply the name of the virtual environment you want to create."
	exit 1
    else
        python3 -m venv "$WORKON_HOME"/"$1"
    fi
    workon "$1"
}

