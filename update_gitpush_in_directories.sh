#!/bin/bash

#version 1.5
#update gitpush in sub dirs with exception
myname="GitPush Update Script"

# example: $fBegin$fRed"  some text"$fEnd
fBegin='\e['
fRed='31m'
fGreen='32m'
fPurple='35m'
fBU='1;4m'
fB='1m'
fEnd='\e[0m'

checkError () {
    if [ $1 -eq 0 ]
    then
        result="["$fBegin$fGreen"ok"$fEnd"]"
    else
        result="["$fBegin$fRed"error"$fEnd"]"
    fi
}
result='notSet'

$n='\n'

DirExclude='githelper'
GitPushFile='gitpush.sh'
GitPushFileFull=$DirExclude'/'$GitPushFile
clear
echo
echo -e $fBegin$fBU"$myname"$fEnd
echo
echo -e '  Excluded directory:\t'$fBegin$fPurple"$DirExclude"$fEnd
echo -e '  GitPush Script:\t'$fBegin$fPurple"$GitPushFileFull"$fEnd

if [ ! -f "$GitPushFileFull" ]; then
    echo
    echo -e $fBegin$fRed"  GitPush Script \"$GitPushFileFull\" not found!"$fEnd
    echo
    exit
fi

echo
echo '  Going to update gitpush script in following subdirectories:'
echo

arrTargetDirs=()
for directory in */ ; do
   if [ "$directory" = "$DirExclude/" ]
   then
       continue
   fi
   arrTargetDirs+=("$directory")
done

subDirsTotal=${#arrTargetDirs[@]}
counter=0
for dir in ${arrTargetDirs[@]}; do
    counter=$(( $counter + 1 ))
    strOut=''
    if [ $counter -eq 1 ]
    then
        strOut=$strOut'    '
    fi
    strOut=$strOut$counter") "$fBegin$fGreen"$dir"$fEnd
    if [ $counter -eq $subDirsTotal ]
    then
        strOut=$strOut'.'
        echo -n -e $strOut
        break
    else
       strOut=$strOut"; " 
       echo -n -e "$strOut" 
    fi
done
echo
echo
echo "  - press Enter or \"yes\" to confirm;"
echo '  - press Ctrl+C, or type something else to cancel.'
if [ "$1" = "" ]
then
     read confirm
fi

if [ "$confirm" = "" ] && [ "$1" = "" ]
then
    confirm='yes'
fi

if [ "$confirm" = "" ] && [ "$1" = "f" ]
then
    confirm='yes'
fi

if [ ! "$confirm" = "yes" ]
then
    echo '  - script canceled, user input is: ' $confirm
    echo -e $fBegin$fRed"  Script canceled, confirm code is: "\"$confirm\"$fEnd
    echo
    exit
fi

clear
echo -e $fBegin$fBU"$myname"$fEnd
echo
echo -e "  Updating "\"$fBegin$fPurple"$GitPushFile"$fEnd\"" in subdirectories..."
echo
counter=0
for destDir in ${arrTargetDirs[@]}; do
    counter=$(( $counter + 1 ))
    cp -- "$GitPushFileFull" "$destDir" > /dev/null 2>&1
    eCode=$?
    checkError $eCode 
    echo -e '  '$result'\t'$destDir
done

echo 
echo -e $fBegin$fB'End of '"$myname"$fEnd
echo
