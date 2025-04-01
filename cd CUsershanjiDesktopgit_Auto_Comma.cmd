C:\auto_git_push\Today-s_Study
git pull

set "today=%date:~0,4%-%date:~5,2%-%date:~8,2%"
set "time=%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "time=%time: =0%"

mkdir "%today%"

echo. > "%today%/%today%-%time%.c"

git add .
git commit -m "today study update"
git push -u origin main
