#!/bin/sh

fkill() {
    local pids=$(
      ps -f -u $USER | sed 1d | fzf --multi | tr -s [:blank:] | cut -d' ' -f2
      )
    if [[ -n $pids ]]; then
        echo "$pids" | xargs kill -9 "$@"
    fi
}

gll() {
    local selections=$(
      git ll --color=always "$@" |
        fzf --ansi --no-sort --no-height \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [[ -n $selections ]]; then
        local commits=$(echo "$selections" | sed 's/^[* |]*//' | cut -d' ' -f1 | tr '\n' ' ')
        git show $commits
    fi
}
