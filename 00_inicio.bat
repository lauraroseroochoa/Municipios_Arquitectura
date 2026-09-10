@echo off
setlocal enabledelayedexpansion

echo Comprobando Git, Docker, Python y Visual Studio Code...

rem --- Comprobar Python ---
where python >nul 2>&1
if !errorlevel!==0 (
    for /f "tokens=*" %%i in ('python --version 2^>nul') do set PYTHON_VER=%%i
    echo Python instalado: !PYTHON_VER!
) else (
    echo Python no encontrado.
    echo Por favor instale Python desde https://www.python.org/ y asegurese de agregarlo al PATH.
)

rem --- Comprobar Git ---
where git >nul 2>&1
if !errorlevel!==0 (
    for /f "tokens=*" %%i in ('git --version 2^>nul') do set GIT_VER=%%i
    echo Git instalado: !GIT_VER!
) else (
    echo Git no encontrado.
    echo Por favor instale Git desde https://git-scm.com/ y vuelva a ejecutar este script.
)

rem --- Comprobar Docker Desktop ---
where docker >nul 2>&1
if !errorlevel!==0 (
    for /f "tokens=*" %%i in ('docker --version 2^>nul') do set DOCKER_VER=%%i
    echo Docker instalado: !DOCKER_VER!
) else (
    echo Docker no encontrado.
    echo Por favor instale Docker Desktop desde https://www.docker.com/get-started y vuelva a ejecutar este script.
)

rem --- Comprobar Visual Studio Code ---
where code >nul 2>&1
if !errorlevel!==0 (
    for /f "tokens=*" %%i in ('code --version 2^>nul') do (
        set CODE_VER=%%i
        goto :vsc_done
    )
) else (
    echo Visual Studio Code no encontrado.
    echo Por favor instale Visual Studio Code desde https://code.visualstudio.com/ y vuelva a ejecutar este script.
    goto :clone
)

:vsc_done
echo Visual Studio Code instalado. Version: !CODE_VER!

rem --- Clonar repositorio si no existe ---
:clone
set REPO_URL=https://github.com/lauraroseroochoa/Municipios_Arquitectura.git
set REPO_DIR=Municipios_Arquitectura

if exist "%CD%\%REPO_DIR%" (
    echo El repositorio ya existe en %CD%\%REPO_DIR%. Se intentara actualizar.
    pushd "%REPO_DIR%"
    if exist .git (
        git pull || echo No se pudo actualizar el repositorio con git pull.
    ) else (
        echo La carpeta existe pero no parece ser un repositorio git.
    )
    popd
) else (
    echo Clonando %REPO_URL% en %CD%...
    git clone %REPO_URL%
    if !errorlevel! neq 0 (
        echo Error al clonar el repositorio. Asegurese de que Git esta instalado y tiene acceso a internet.
    )
)

rem --- Entrar al repositorio ---
cd Introduccion

rem --- Crear y activar entorno virtual Python (env) ---
set "ENV_DIR=env"

if not exist "%ENV_DIR%" (
    echo.
    echo Creando el entorno virtual '%ENV_DIR%'...
    python -m venv %ENV_DIR%
    if !errorlevel!==0 (
        echo Entorno virtual creado exitosamente.
    ) else (
        echo Error al crear el entorno virtual.
    )
) else (
    echo.
    echo El entorno virtual '%ENV_DIR%' ya existe.
)

if exist "%ENV_DIR%\Scripts\activate.bat" (
    echo Activando entorno virtual...
    call "%ENV_DIR%\Scripts\activate.bat"
    
    rem --- Instalar dependencias si existe requirements.txt ---
    if exist "requirements.txt" (
        echo Instalando dependencias desde requirements.txt...
        pip install -r requirements.txt
    )
) else (
    echo ADVERTENCIA: No se pudo activar el entorno virtual.
)

rem --- Ejecutar el siguiente script de la secuencia ---
if exist "01_encadenador.bat" (
    call 01_encadenador.bat
)

echo Proceso finalizado.
endlocal
