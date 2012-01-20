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

function update_moodbar
{
    # from http://amarok.kde.org/wiki/Moodbar
    DIR=/media/shared/Music/Music/
    LAST=$HOME/.moodbar-lastreadsong
    C_RET=0

    control_c()        # run if user hits control-c
    {
	echo "$1" > "$LAST"
	echo "Exiting..."
	exit
    }

    if [ -e "$LAST" ]; then
	read filetodelete < "$LAST"
	rm "$filetodelete" "$LAST"
    fi
    exec 9< <(find "$DIR" -type f -regextype posix-awk -iregex '.*\.(mp3|ogg|flac|wma|m4a|mp4)') # you may need to add m4a and mp4
    while read i
    do
	TEMP="${i%.*}.mood"
	OUTF=`echo "$TEMP" | sed 's#\(.*\)/\([^,]*\)#\1/.\2#'`
	trap 'control_c "$OUTF"' INT
	if [ ! -e "$OUTF" ] || [ "$i" -nt "$OUTF" ]; then
	    moodbar -o "$OUTF" "$i" || { C_RET=1; echo "An error occurred!" >&2; }
	fi
    done <&9
    exec 9<&-
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
