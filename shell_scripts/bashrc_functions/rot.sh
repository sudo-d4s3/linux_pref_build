#!/bin/sh

function rot13() { if [ -r $1 ]; then cat $1 | tr '[N-ZA-Mn-za-m5-90-4]' '[A-Za-z0-9]'; else echo $* | tr '[N-ZA-Mn-za-m5-90-4]' '[A-Za-z0-9]'; fi }

function rot47() { if [ -r $1 ]; then cat $1 | tr '\!-~' 'P-~\!-O' ; else echo $* | tr '\!-~' 'P-~\!-O'; fi }
