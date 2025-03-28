#!/bin/bash
MESSAGE="Default commit - forgot message"
CHANGE=false
PUSH=false
while getopts "m:p" opt; do
  case ${opt} in
    m)
      MESSAGE=${OPTARG};
      CHANGE=true
      ;;
    p)
      PUSH=true
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

if [ $CHANGE = false ]; then
  echo "Do you want to commit with a default message? Enter y to continue."
  read temp 
  if [ "$temp" != "y" ]; then 
    echo "Quitting..."
    exit
  fi 
fi 
git add .
git commit -m "$MESSAGE"
if [ $PUSH = true ]; then 
  git push
fi 
