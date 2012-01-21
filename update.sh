#!/usr/bin/env zsh

conf_dir=$HOME/.update
funcs_dir=$HOME/.update/funcs
conf_file=$HOME/.update/updaterc

. $conf_file
for f in $(find $funcs_dir -type f); do
    . $f;
done

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
