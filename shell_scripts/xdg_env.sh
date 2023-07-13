#!/bin/bash

export HISTFILE="$XDG_STATE_HOME"/bash/history

export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

# This assumes you're not using a gui login manager
export SERXSESSION="$XDG_CACHE_HOME/X11/xsession"
export SERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
export LTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
export RRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod

export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python

export XDG_CONFIG_HOME/git/config 
