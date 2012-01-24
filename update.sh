#!/usr/bin/env zsh

conf_dir=$HOME/.update
funcs_dir=$HOME/.update/funcs
conf_file=$HOME/.update/updaterc
blacklist_token="no_auto_"

. $conf_file
for f in $(find $funcs_dir -type f); do
    . $f;
done

function find_functions
{
    functions | grep -Eo '^('$blacklist_token')?(update_[_a-zA-Z]+)'
}

function find_auto_update_functions
{
    find_functions | grep -Ev '^('$blacklist_token')(update_[_a-zA-Z]+)'
}

function update_all
{
    for f in $(find_auto_update_functions) ; do
	info update "running $f"
	[[ $f != "update_all" ]] && $f && info update "$f done" || error "$f";
    done
}

function invalid_function
{
    echo "No update function for $1\n"
    usage
}

function usage
{
    funcs=$(find_functions | sed -e 's/.*update_/  /')
    echo "Valid functions are:"
    echo "$funcs"
}

target="update_$1"
found=$(whence -w $target)
if [[ $found == "$target: none" ]] ; then
    target="$blacklist_token$target"
    found=$(whence -w $target)
fi

[[ $found != "$target: none" ]] && $target || invalid_function $1
