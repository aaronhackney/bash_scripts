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

echo "Creating project skeleton for $1"


# Create the directories 
mkdir -p $projectname
mkdir -p $projectname/tests
touch $projectname/tests/__init__.py
mkdir -p docs

if [[ ! -e requirements.txt ]]; then
    touch requirements.txt
fi

if [[ ! -e CHANGES.txt ]]; then
    touch CHANGES.txt
fi

# Create the __init__.py file for the package
cat <<EOT > $projectname/__init__.py
"""
$projectname
"""

__version__ = "0.1.0"

EOT

# create a skeleton of a test file
cat <<EOT > $projectname/tests/test_$projectname.py
from unittest import TestCase


class Test$projectname(TestCase):
    def setUp(self):
        pass
    
    def test_$projectname(self):
        self.assertTrue(True)

EOT

# Load the license text & Create the license file
source "$(dirname "$0")/LICENSE.sh"
echo "$LICENSE" > LICENSE.txt

# Create the MANIFEST.in file
cat <<EOT > MANIFEST.in
include *.txt
recursive-include docs *.txt
EOT

# Create the README.md file
cat <<EOT > README.md
# $projectname
EOT

# Create the requirements.txt file
cat <<EOT > requirements.txt
wheel>=0.36.2
black>=20.8b1
flake8>=3.8.4
rope>=0.18.0
EOT

# Create the setup.cfg file
cat <<EOT > setup.cfg
[metadata]
description-file = README.md
EOT

# create setup.py
cat <<EOT > setup.py
import setuptools
import codecs
import os


def read(rel_path):
    here = os.path.abspath(os.path.dirname(__file__))
    with codecs.open(os.path.join(here, rel_path), "r") as fp:
        return fp.read()


def get_version(rel_path):
    for line in read(rel_path).splitlines():
        if line.startswith("__version__"):
            delim = '"' if '"' in line else "'"
            return line.split(delim)[1]
    else:
        raise RuntimeError("Unable to find version string.")


setuptools.setup(
    name="$projectname",
    packages=setuptools.find_packages(),
    version=get_version("$projectname/__init__.py"),
    license="GPL 3.0 https://www.gnu.org/licenses/gpl-3.0.txt",
    description="$projectname",
    author="Aaron K. Hackney",
    author_email="aaron_309@yahoo.com",
    url="https://github.com/aaronhackney/afitop100",
    download_url="",
    # keywords=["afi", "top 100", "films", "movies", "all time", "american", "film", "institute"],
    # install_requires=["beautifulsoup4", "requests", "pandas"],
    # entry_points={"console_scripts": ["$projectname = $projectname.__main__:main"]},
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Topic :: Utilities",
        "License :: OSI Approved :: GNU General Public License (GPL)",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
    ],
)
EOT

# Create the Makefile
cat <<EOT > Makefile
HOST=127.0.0.1
PACKAGE:=$projectname

.PHONY : clean
.DEFAULT_GOAL = help

help:
	@echo "--------------------HELP-----------------------"
	@echo "To test the project type make test"
	@echo "To clean the build files type make clean-build"
	@echo "-----------------------------------------------"

clean:
	find . -name '*.pyc' -exec rm -rf {} +
	find . -name '*.pyo' -exec rm -rf {} +

clean-build:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info

test: clean
	/usr/local/bin/python3 -m unittest discover -v -s ./$projectname/tests/ -p 'test_*.py'
EOT

# Create a .gitignore file
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

