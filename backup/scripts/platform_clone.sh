#!/bin/bash

GITLAB_BASE="git@gitlab.com:the-platform-group/"
GITLAB_END=".git"

GITLAB_PROJECTS=(
 "admin-app/admin-fe"
 "irwin-app/irwin-api"
 "irwin-app/irwin-fe"
 "irwin-app/factset-etl"
)

function clone_project(){
  echo -e "\e[34m Cloning $1 \e[0m"
  git clone "${GITLAB_BASE}${1}${GITLAB_END}" $1
  echo ""
}

for project in ${GITLAB_PROJECTS[@]}
do
  clone_project $project
done
