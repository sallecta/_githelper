export LC_ALL=C.utf-8
#version 1.7.1

fn_stoponerror () {
if [ $1 -ne 0 ]; then
        lNo=$(expr $2 - 1)
        printf "  [Error at line No $lNo. $2]\n\n"
        exit
else
   printf "\n$lNo    [Success]\n\n"
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
git_app="git"
$git_app config credential.helper store
fn_stoponerror "$?" $LINENO
$git_app add *
fn_stoponerror "$?" $LINENO
$git_app add -u
fn_stoponerror "$?" $LINENO
echo 'Check status:' 
$git_app status
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

$git_app commit --message="$commmitMessage"
fn_stoponerror "$?" $LINENO

$git_app push

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "git push error, reseting git commit"
    git reset --soft HEAD~1
fi
exit $retVal
