#!/bin/bash
target_os=${target:-"debian"}
cat _partial/Dockerfile.${target_os} _partial/Dockerfile_ > Dockerfile
