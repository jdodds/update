#!/usr/bin/env zsh

action=$1
conf_dir=$HOME/.$action
funcs_dir=$HOME/.$action/funcs
conf_file=$HOME/.$action/"$action"rc
blacklist_token="no_auto_"


. $conf_file
for f in $(find $funcs_dir -type f); do
    . $f;
done

function find_functions
{
    functions | grep -Eo '^('$blacklist_token')?('$action'_[_a-zA-Z]+)'
}

function find_auto_functions
{
    find_functions | grep -Ev '^('$blacklist_token')('$action'_[_a-zA-Z]+)'
}

function all
{
    for f in $(find_auto_functions) ; do
	info $action "running $f"
	[[ $f != "$action_all" ]] && $f && info $action "$f done" || error "$f";
    done
}

function invalid_function
{
    echo "No $action function for $1\n"
    usage
}

function usage
{
    funcs=$(find_functions | sed -e 's/.*'$action'_/  /')
    echo "Valid functions are:"
    echo "$funcs"
}

target="$action"_"$2"
found=$(whence -w $target)
if [[ $found == "$target: none" ]] ; then
    target="$blacklist_token$target"
    found=$(whence -w $target)
fi

[[ $found != "$target: none" ]] && $target || invalid_function $2

