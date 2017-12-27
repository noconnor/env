#!/usr/bin/env bash
#set -e

function install_homebrew(){
    if [ -z "$(which brew)" ]; then
        echo "Installing brew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || (>&2 echo "Error installing brew") && exit 1
    fi
    echo "Updating brew..."
    brew update
}

function install_python3(){
    if [ -z "$(which python3)" ]; then
        echo "Installing python3..."
        brew install python3 || (>&2 echo "Error installing python 3")  && exit 1
    fi

    if [ -z "$(grep 'alias python' ${HOME}/.bash_profile)" ]; then
        echo "alias python=python3" >> ${HOME}/.bash_profile
        PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
        echo "PATH=$PYTHON_BIN_PATH:$PATH" >> ${HOME}/.bash_profile
    fi
    [ -z "$(grep 'alias pip' ${HOME}/.bash_profile)" ] && echo "alias pip=pip3" >> ${HOME}/.bash_profile
    source ${HOME}/.bash_profile
}

function install_pipenv(){
    echo "Installing pipenv..."
    source ${HOME}/.bash_profile
    pip install --user pipenv
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
    source ${HOME}/.bash_profile
}

function install_docker() {
    echo "Installing docker..."
    if [ ! -f "/usr/local/bin/docker" ]; then
        brew install docker docker-compose docker-machine xhyve docker-machine-driver-xhyve || (>&2 echo "Error installing docker") && exit 1
        sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
        sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    fi
}

install_homebrew
install_python3
install_pipenv
install_aliases
install_gitprompt
install_docker

exit 0
