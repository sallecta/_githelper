## CC BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/
## based on
## https://stackoverflow.com/a/26000395
## by marsnebulasoup https://stackoverflow.com/users/8402369/marsnebulasoup
## and Desta Haileselassie Hagos https://stackoverflow.com/users/1731796/desta-haileselassie-hagos
git checkout --orphan latest_branch
git add -A
git commit -am "..."
git branch -D main
git branch -m main
git push -f origin main
