#!/bin/bash
# target_os=${target:-"debian"}
# cat _partial/Dockerfile.${target_os} _partial/Dockerfile_ > Dockerfile

# curl   -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/Dreamacro/clash/git/matching-refs/tags | grep -o 'v[0-9\.]\+' | sort -u

#  docker images | grep none | grep -o "[a-f0-9]\{6,\}" | xargs docker rmi


if [ -z $1 ]
then
    echo "Usage: ./create_docker_file.sh [clash_version]"
    exit 1
fi

OS_LIST="debian alpine"

for target_os in $OS_LIST
do
    cat _partial/Dockerfile.${target_os} _partial/Dockerfile_ \
        | sed "s/^ARG CLASH_VERSION$/ARG CLASH_VERSION=${1}/g" \
        > Dockerfile.${target_os}
done

echo "New Dockerfile(s) created."

# sed '/Supported tags and respective Dockerfile links/,/Other Reference/p' README.md
# git log -1 | head -n 1 | grep -o "[0-9a-f]\{40,\}"

