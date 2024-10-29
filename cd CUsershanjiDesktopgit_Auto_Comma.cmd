cd C:\Users\hanji\Desktop\git_Auto_Command
#del /Q *.txt
git pull

set "today=%date:~0,4%-%date:~5,2%-%date:~8,2%"
set "time=%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "time=%time: =0%"
echo. > "%today%_%time%.c"


git add .
git commit -m "today study update"
git push -u origin main