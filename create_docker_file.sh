#!/bin/bash
target_os=${target:-"debian"}
cat _partial/Dockerfile.${target_os} _partial/Dockerfile_ > Dockerfile

# curl   -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/Dreamacro/clash/git/matching-refs/tags | grep -o 'v[0-9\.]\+' | sort -u
