#!/bin/bash

#version 1.7

fn_stoponerror () {
if [ $1 -ne 0 ]; then
        lNo=$(expr $2 - 1)
        printf "  [Error at line No $lNo. $2]\n\n"
        exit
else
   printf "    [Success]\n\n"
fi
}

if [ "$1" = "up" ]
then
    echo " - called from child folder. Checking child path"
	if [ ! -d "$2" ]; then
	  echo "   -- child path does not exist. Exit"
	  exit 1
	else
	  mypath="$PWD"
	  childpath="$2"
	  echo "   -- child path exist, changing woring directory to $childpath"
	  cd $childpath
	  fn_stoponerror "$?" $LINENO
	fi    
fi

git config credential.helper store
fn_stoponerror "$?" $LINENO
git add .gitignore
fn_stoponerror "$?" $LINENO
git add -u
fn_stoponerror "$?" $LINENO
echo 'Check status:' 
git status
fn_stoponerror "$?" $LINENO

echo "- press Enter to upload (push) with commit message \"...\""
echo '- type commit message and press Enter to upload (push);'
echo '- type Ctrl+C to cancel.'
read commmitMessageUsr

if [ "$commmitMessageUsr" = "" ]  && [ "$commmitMessageArg" = "" ]
then
    commmitMessage='...'
fi
if [ ! "$commmitMessageArg" = "" ]  && [ "$commmitMessageUsr" = "" ]
then
    commmitMessage=$commmitMessageArg
fi
if [ ! "$commmitMessageUsr" = "" ]
then
    commmitMessage=$commmitMessageUsr
fi

echo commit message is \"$commmitMessage\"

git commit --message="$commmitMessage"
fn_stoponerror "$?" $LINENO

git push

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "git push error, reseting git commit"
    git reset --soft HEAD~1
fi
exit $retVal
