#!/usr/bin/env bash

if [ "$#" -lt 2 ] || [ "$1" == "-h" ]; then 
    echo "Uso: $(basename $0) [distro] [playbook] [host]"
    exit
fi

[ -f $HOME/.keys/vars ] && source $HOME/.keys/vars

distro="$1"
playbook="$2"
machine="$3"

[ "${distro,,}" == "centos" ] && distro="rocky"
[ ! -f $1/*-$2.yml ] && echo "O playbook não existe." && exit

if [ "$3" == "-v" ]; then
    cd $1
    if ! vagrant status | grep -q 'running'; then
        vagrant up
    fi
    ln -sf *-"$2".yml playbook.yml
    vagrant provision
else
    ansible-playbook -i "$machine", "$distro"/*-"$playbook".yml
fi