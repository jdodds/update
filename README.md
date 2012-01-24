Overview
=========

This is a simple tool for pulling in updates from various things. I got sick of
tracking them mostly-manually.

By default after running `make install`:

`~/.update/updaterc` is the configuration file. This currently just defines two
functions, `info` and `error`, which are meant to provide info and error level
notifications, respectively. The ones provided use `notify-send`, you can use
whatever you want.

`~/.update/funcs` is a directory under which you should define your update
functions. Every file under this directory is sourced, so you can stick
everything in one file or do whatever type of script organization you want.

Defining Update Functions
=========================

The only hard rule is that their name *must* start with `update_`, and they
should follow normal semantics for return values. Other than that, you can do
whatever you want. Here's the function I use to update emacs' source:

    function update_emacs
    {
        cd ~/workspace/emacs
        bzr pull
        (make && sudo make install) || (make bootstrap && make && sudo make install)
    }

Easy-peasy, if perhaps dangerously simple.

Occasionally, you may run into something that you'd like to have an update
definition for, but do not want to run when `update all` is called. To mark a
function as blacklisted, prefix it's name with `no_auto_`. This is configurable
by setting `blacklist_token` to whatever you'd like the prefix to be in your `updaterc`

Caveats
=======

Function-files are sourced, so if for some inane reason you let someone
malicious write them they could do malicious things.

I've only tested and used this with zsh. It almost definitely won't work with
anything else, although that's probably just a matter of the way that the update
functions are found.


Bug Reports and Contributions
=============================

Please do. On github.
