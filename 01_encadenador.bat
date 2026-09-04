@echo off

start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"

echo.
echo Esperando a que Docker Desktop este listo...

:waitDocker
docker info >nul 2>nul
if errorlevel 1 (
    timeout /t 3 /nobreak >nul
    goto waitDocker
)

echo.
echo Docker listo.

echo.
echo Esperando a que VSCode este listo...

start "" code .

:waitVSCode
timeout /t 1 /nobreak >nul
tasklist /FI "IMAGENAME eq Code.exe" 2>nul | find /I "Code.exe" >nul
if errorlevel 1 goto waitVSCode

echo.
echo VSCode listo.

powershell -command "Start-Sleep 3; $wshell = New-Object -ComObject WScript.Shell; $wshell.AppActivate('Visual Studio Code'); Start-Sleep 1; $wshell.SendKeys('%%t'); Start-Sleep -Milliseconds 400; $wshell.SendKeys('n'); Start-Sleep 2; $wshell.SendKeys('.\02_creacionBD.bat{ENTER}')"

:waitMariaDB
docker exec mariadb_db mariadb -u root -proot123 -e "USE entidadesTerritorialesColombia; SHOW TABLES;" >nul 2>&1
if errorlevel 1 (
    timeout /t 10 /nobreak >nul
    goto waitMariaDB
)

powershell -command "Start-Sleep 1; $wshell = New-Object -ComObject WScript.Shell; $wshell.AppActivate('Visual Studio Code'); Start-Sleep 1; $wshell.SendKeys('^+5'); Start-Sleep 2; $wshell.SendKeys('.\03_conexionBD.bat{ENTER}')"
