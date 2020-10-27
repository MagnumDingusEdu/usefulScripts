#!/bin/bash
function _blah(){ curl -s  -H  "Authorization: token <your-token>" --data "{\"name\":\"$1\",\"private\":\"$2\"}"  https://api.github.com/user/repos | jq '.ssh_url' --raw-output; };_blah $1 $2
