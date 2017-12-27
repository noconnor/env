#!/usr/bin/env bash
set -e

function install_homebrew(){
    if [ -z "$(which brew)" ]; then
        echo "Installing brew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || (>&2 echo "Error installing brew")
    fi
    echo "Updating brew..."
    brew update
}

function install_python3(){
    if [ -z "$(which python3)" ]; then
        echo "Installing python3..."
        brew install python3 || (>&2 echo "Error installing python 3")
    fi
    [ -z "$(grep 'alias python' ${HOME}/.bash_profile)" ] && echo "alias python=python3" >> ${HOME}/.bash_profile
    source ${HOME}/.bash_profile
}

function install_pipenv(){
    echo "Installing pipenv..."
    pip install --user pipenv || (>&2 echo "Error installing pipenv")
}

function install_aliases(){
    echo "Installing aliases..."
    [ -z "$(grep 'alias ll' ${HOME}/.bash_profile)" ] && echo "alias ll='ls -al'" >> ${HOME}/.bash_profile
}

function install_gitprompt() {
    echo "Installing git-prompt..."
    current_dir=$(cd $(dirname "$BASH_SOURCE") && pwd)
    if [ -z "$(grep 'git-prompt' ${HOME}/.bash_profile)" ]; then
        source "${current_dir}/git-prompt.sh"
        echo "source ${current_dir}/git-prompt.sh" >> ${HOME}/.bash_profile
        echo "PS1='[\u@\h \W\$(__git_ps1 \" (%s)\")]\$ '" >> ${HOME}/.bash_profile
    fi
    source ${HOME}/.bash_profiles
}

install_homebrew
install_python3
install_pipenv
install_aliases
install_gitprompt

exit 0
