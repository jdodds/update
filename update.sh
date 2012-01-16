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
    (make && sudo make install) || (make bootstrap && make && sudo make install) || error emacs
}

function update_system
{
    sudo pacman -Syu --noconfirm --logfile $HOME/log/update_system.log || error "system update"
}

function update_pear
{
    sudo /usr/bin/pear clear-cache
    sudo /usr/bin/pear update-channels 2> $HOME/log/pear.log
    sudo /usr/bin/pear upgrade 2> $HOME/log/pear.log
}

function update_org_feeds
{
    emacs --batch --eval '(load "~/.emacs")' -f 'org-feed-update-all'
}

function find_functions
{
    functions | grep -Eo '^(update_[_a-zA-Z]+)'
}

function update_all
{
    for f in $(find_functions) ; do
	info update "running $f"
	[[ $f != "update_all" ]] && $f && info update "$f done";
    done
}

function invalid_function
{
    funcs=$(find_functions | sed -e 's/update_/  /')
    echo "No update function for $1\n"
    echo "Valid functions are:"
    echo "$funcs"
}

target="update_$1"
[[ $(whence -w $target) != "$target: none" ]] && \
    $target || \
    invalid_function $1
