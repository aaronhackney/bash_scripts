#! /bin/bash

# Create a typical Python Project Structure:
# Makefile
# requirements.txt 
# setup.py
# setup.cfg
# ./projectName/
# ./tests/
# ./docs/


if [ "$1" = "" ]; then
    printf "You need to supply the name of the project we are creating.\n"
    printf "Usage: mkpythonproject.sh [project-name]\n"
    exit 1
else
    projectname=$1
fi

printf "Creating project skeleton for $1"

# Create the directories 
mkdir -p $projectname
mkdir -p tests
mkdir -p docs

if [[ ! -e Makefile ]]; then
    touch Makefile
fi

if [[ ! -e requirements.txt ]]; then
    touch requirements.txt
fi

if [[ ! -e setup.cfg ]]; then
    printf "[metadata]\nname = $projectname\nversion = 0.1\n" > setup.cfg
fi

if [[ ! -e setup.py ]]; then
        printf "import setuptools\n\nsetuptools.setup()\n" > setup.py
fi

cat <<EOT >> .gitignore
# Compiled python modules.
*.pyc

# IDE related files/folders
.idea
*.iml
*.ipr
*.iws
.vscode*

# Build Artifacts
/dist/
/pip-wheel-metadata/

# Python egg metadata, regenerated from source files by setuptools.
/*.egg-info
/*.egg
.eggs/
build/

# VirtualEnvironment Files
/.venv*
/bin/
/include/
/lib/
lib64
pip-selfcheck.json
.Python
pyvenv.cfg
/share/
env
venv/

# Test Artifacts
/.mypy_cache/
/.tox/

# Manifest generated by setuptools
MANIFEST

# Auto-generated webpage
docs/gh-pages/

# mac
.DS_Store

# pre-commit configuration yaml file
.pre-commit-config.yaml
EOT
