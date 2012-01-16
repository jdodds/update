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
    info emacs updating
    cd $HOME/workspace/emacs
    bzr pull
    (make && sudo make install && info emacs done) || (make bootstrap && make && sudo make install && info emacs done) || error emacs
}

function update_system
{
    info system updating
    sudo pacman -Syu --noconfirm --logfile $HOME/log/update_system.log && info system updated || error "system update"
}

function update_pear
{
    info pear updating
    sudo /usr/bin/pear clear-cache
    sudo /usr/bin/pear update-channels 2> $HOME/log/pear.log
    sudo /usr/bin/pear upgrade 2> $HOME/log/pear.log
    info pear done
}

function update_org_feeds
{
    info org_feeds updating
    emacs --batch --eval '(load "~/.emacs")' -f 'org-feed-update-all'
    info org_feeds done
}

function update_all
{
    for f in $(functions | grep -Eo '^(update_[_a-zA-Z]+)'); do
	[[ $f != "update_all" ]] && $f;
    done
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
