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
echo Ejecutando script de creacion de BD...
call .\02_creacionBD.bat

:waitMariaDB
docker exec mariadb_db mariadb -u root -proot123 -e "USE entidadesTerritorialesColombia; SHOW TABLES;" >nul 2>&1
if errorlevel 1 (
    timeout /t 10 /nobreak >nul
    goto waitMariaDB
)

echo.
echo Abriendo VSCode y conectando a la terminal interactiva...
start "" code .

rem Abrimos directamente la consola interactiva de MariaDB en una ventana/terminal secundaria limpia
start cmd /k "docker exec -it mariadb_db mariadb -u root -proot123 entidadesTerritorialesColombia"
