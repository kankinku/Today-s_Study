cd C:\Users\hanji\Desktop\git_Auto_Command
git pull

rem 날짜와 시간을 설정합니다.
set "today=%date:~0,4%-%date:~5,2%-%date:~8,2%"
set "time=%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "time=%time: =0%"

rem 오늘 날짜에 해당하는 디렉토리를 생성합니다 (이미 있으면 건너뜀).
mkdir "%today%"

rem 생성된 날짜 디렉토리 안에 시간을 포함한 새 파일을 만듭니다.
echo. > "%today%\%time%.c"

git add .
git commit -m "today study update"
git push -u origin main
