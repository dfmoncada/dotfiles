#!/bin/bash

GITLAB_PROJECTS=(
 "admin-app/admin-fe"
 "irwin-app/irwin-api"
 "irwin-app/irwin-fe"
 "irwin-app/factset-etl"
)

COMMAND_SETUPS=(
  "npm install"
  "bundle install; bin/setup"
  "npm install"
  "npm install"
)

function setup_project(){
  source_path=$(pwd)
  path=${GITLAB_PROJECTS[$1]}
  setup_command=${COMMAND_SETUPS[$1]}

  echo -e "\e[34m Setting up $path \e[0m"

  cd $path
  eval $setup_command
  cd $source_path
}

len=${#GITLAB_PROJECTS[@]}
for (( i=0; i<$len; i++ ));
do
  setup_project $i
done
