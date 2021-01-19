#!/bin/bash


prefix="${PWD##*/}_"
data_dir="data"
config_file="$data_dir/config.yaml"
backup_dir="data/config_backup"

if docker ps | grep $prefix
then
  echo "Containers are RUNNING! Please run 'docker-compose stop' to stop them first."
  exit 1
else
  echo "NOT Running!"
fi

if [[ ! -f "$data_dir/entrypoint.sh" ]]; then
    echo "copying entrypoint file to $data_dir"
    echo "warning: you may need to copy clash-linux, Country.mmdb to $data_dir"
    echo "Refer to README for more info."
    mkdir -p $data_dir
    cp _partial/entrypoint.sh "$data_dir/"
fi

if [[ ! -f "$data_dir/clash-linux" ]]; then
    echo "warning: you may need to copy clash-linux, Country.mmdb to $data_dir."
    echo "Refer to README for more info."
fi

new_config=${1:-"game.yml"}

if [[ -f $new_config ]]; then
    echo "Using new config [$new_config]"
else
    echo "File [$new_config] NOT FOUND!"
    exit 1
fi

mkdir -p $backup_dir
backup_file="$backup_dir/clash_config.$(date +%Y-%m-%d_%H-%M-%S).yaml"
mv $config_file $backup_file
cat _partial/_config.partial.yaml > $config_file
sed -e '1,/^proxies:$/ d' $new_config >> $config_file

