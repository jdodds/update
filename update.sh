#!/usr/bin/env zsh
function info
{
    notify-send -i info "$1" "$2"
}

function error
{
    notify-send -i error "$1" failed!
}

function update_emacs
{
    cd $HOME/workspace/emacs
    bzr pull
    (make && sudo make install && info emacs done) || (make bootstrap && make && sudo make install && info emacs done) || error emacs
}

function update_system
{
    sudo pacman -Syu --noconfirm --logfile $HOME/log/update_system.log && info system updated || error "system update"
}

function update_pear
{
    pear clear-cache
    pear update-channels 2> $HOME/log/pear.log
    pear upgrade 2> $HOME/log/pear.log
}

function update_org_feeds
{
    emacs --batch --eval '(load "~/.emacs")' -f 'org-feed-update-all'
}

function update_all
{
    update_system
    update_pear
    update_emacs
    update_org_feeds
}

funcs=$(functions | grep -Eo '^update_([_a-zA-Z]+) ' | sed -e 's/update_/  /')

target="update_$1"
if [[ $(whence -w $target) != "$target: none" ]] ; then
    $target
else
    echo "No update function for $1\n"
    echo "Valid functions are:"
    echo "$funcs"
fi
