#! /bin/bash

dt=$(date +'%Y%m%d%H%m%S')

/bin/cp ~/.config/opencode/config.json ~/.config/opencode/config.json.${dt}
if [ -f ~/.config/opencode/config.json ]; then
    diff -u ~/.config/opencode/config.json config.global.json
    echo $?
fi

/bin/cp config.global.json ~/.config/opencode/config.json
