#!/bin/bash

#version 1.2
#git add *
#git add **/.gitignore
#git add .gitignore
git add -u 
git status
echo 'Check status:'
echo '- write commit message or just press Enter to upload;'
echo '- type Ctrl+C to cancel.'
read commmitMessage

if [ "$commmitMessage" = "" ]
then
    commmitMessage='...'
fi
echo commit message is \"$commmitMessage\"
git commit --message="$commmitMessage"

if [ "$commmitMessage" = "" ]
then
    commmitMessage='...'
fi
git push

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "git push error, reseting git commit"
    git reset --soft HEAD~1
fi
exit $retVal
