#!/bin/bash

GITLAB_PROJECTS=(
 "admin-app/admin-fe"
 "irwin-app/irwin-api"
 "irwin-app/irwin-fe"
 "irwin-app/factset-etl"
)

START_COMMANDS=(
  "npm start"
  "rails s"
  "npm start"
  "npm start"
)

function start_project(){
  source_path=$(pwd)
  path=${GITLAB_PROJECTS[$1]}
  start_command=${START_COMMANDS[$1]}

  echo -e "\e[34m Starting up $path \e[0m"

  cd $path
  $start_command &
  echo $start_command
  cd $source_path
}

len=${#GITLAB_PROJECTS[@]}
for (( i=0; i<$len; i++ ));
do
  start_project $i
done

wait
