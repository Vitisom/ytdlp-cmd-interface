@echo off
chcp 65001 >nul
title YouTube Downloader PRO 4.7
setlocal EnableDelayedExpansion

:: ===== PATHS =====
set "BASE=%~dp0"
set "YTDLP=%BASE%yt-dlp.exe"
set "MENU=%BASE%menu.ps1"
set "DOWNLOADS=%BASE%Downloads"
set "HISTORICO=%BASE%historico_downloads.txt"

if not exist "%YTDLP%" (
    echo yt-dlp.exe nao encontrado na pasta.
    pause
    exit /b
)

if not exist "%DOWNLOADS%" mkdir "%DOWNLOADS%"

:: ================================
:: DETECTAR JS RUNTIME
:: ================================
set JSRUNTIME=

node -v >nul 2>&1
if %errorlevel%==0 (
 set JSRUNTIME=node
) else (
 deno --version >nul 2>&1
 if %errorlevel%==0 set JSRUNTIME=deno
)

:MENU
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%MENU%"
set "opcao=%errorlevel%"

if !opcao! equ 1 goto :MP3
if !opcao! equ 2 goto :MP4
if !opcao! equ 3 goto :UPDATE
if !opcao! equ 4 exit
goto :MENU

:MP3
set "TOTAL=0"
set "COUNT=0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%MENU%" -submenu mp3
set "qual=%errorlevel%"

if !qual! equ 1 set "aud=0"
if !qual! equ 2 set "aud=2"
if !qual! equ 3 set "aud=5"
if !qual! equ 4 goto :MENU
if !qual! equ 0 goto :MENU

cls
echo ===== DOWNLOAD MP3 - qualidade !aud! =====
echo Cole links separados por virgula (,):
echo.
set "LINKS="
set /p "LINKS=Cole aqui: "

if "!LINKS!"=="" (
    echo Nenhum link informado.
    pause
    goto :MENU
)

set "LINKS=!LINKS: =!"
set "LINKS=!LINKS:,= !"

:: Contagem de links
for %%L in (!LINKS!) do (
    if not "%%L"=="" set /a COUNT+=1
)

cls
echo Iniciando downloads MP3...

for %%L in (!LINKS!) do (
    if "%%L"=="" continue

    echo.
    echo Baixando: %%L
    echo --------------------------------

    "%YTDLP%" --js-runtimes %JSRUNTIME% -x --audio-format mp3 --audio-quality !QUAL! --embed-thumbnail --add-metadata --get-title -- "%%L" > "%TEMP%\titulo.txt" 2>nul
    set /p TITULO=<"%TEMP%\titulo.txt"
    if not defined TITULO set "TITULO=Desconhecido"

    "%YTDLP%" --js-runtimes %JSRUNTIME% -x --audio-format mp3 --audio-quality !QUAL! --embed-thumbnail --add-metadata -o "%DOWNLOADS%\%%(title)s.%%(ext)s" -- "%%L"

    if errorlevel 1 (
        powershell -NoProfile -Command "Write-Host '[ERRO] Falhou em %%L' -ForegroundColor Red"
    ) else (
        if !COUNT! gtr 1 (
            set /a TOTAL+=1
            powershell -NoProfile -Command "Write-Host '[OK] Concluido (!TOTAL!/!COUNT!)' -ForegroundColor Green"
        ) else (
            powershell -NoProfile -Command "Write-Host '[OK] Concluido' -ForegroundColor Green"
        )
        echo %DATE% %TIME% ^| %%L ^| !TITULO! >> "%HISTORICO%"
    )

    timeout /t 2 >nul
)

if !COUNT! gtr 1 (
    echo.
    echo ======================================
    echo TOTAL DE MUSICAS BAIXADAS: !TOTAL! de !COUNT!
    echo ======================================
)

pause
goto :MENU

:MP4
set "TOTAL=0"
set "COUNT=0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%MENU%" -submenu mp4
set "formato=%errorlevel%"

if !formato! equ 1 set "FORMAT=137+140"
if !formato! equ 2 set "FORMAT=22"
if !formato! equ 3 set "FORMAT=135+140"
if !formato! equ 4 goto :MENU
if !formato! equ 0 goto :MENU

cls
echo ===== DOWNLOAD MP4 - formato !FORMAT! =====
echo Cole links separados por virgula (,):
echo.
set "LINKS="
set /p "LINKS=Cole aqui: "

if "!LINKS!"=="" (
    echo Nenhum link informado.
    pause
    goto :MENU
)

set "LINKS=!LINKS: =!"
set "LINKS=!LINKS:,= !"

:: Contagem de links
for %%L in (!LINKS!) do (
    if not "%%L"=="" set /a COUNT+=1
)

cls
echo Iniciando downloads MP4...

for %%L in (!LINKS!) do (
    if "%%L"=="" continue

    echo.
    echo Baixando: %%L
    echo --------------------------------

    "%YTDLP%" %JSRUNTIME% --get-title -- "%%L" > "%TEMP%\titulo.txt" 2>nul
    set /p TITULO=<"%TEMP%\titulo.txt"
    if not defined TITULO set "TITULO=Desconhecido"

    "%YTDLP%" %JSRUNTIME% -f !FORMAT! --embed-thumbnail --add-metadata -o "%DOWNLOADS%\%%(title)s.%%(ext)s" -- "%%L"

    if errorlevel 1 (
        powershell -NoProfile -Command "Write-Host '[ERRO] Falhou em %%L' -ForegroundColor Red"
    ) else (
        if !COUNT! gtr 1 (
            set /a TOTAL+=1
            powershell -NoProfile -Command "Write-Host '[OK] Concluido (!TOTAL!/!COUNT!)' -ForegroundColor Green"
        ) else (
            powershell -NoProfile -Command "Write-Host '[OK] Concluido' -ForegroundColor Green"
        )
        echo %DATE% %TIME% ^| %%L ^| !TITULO! >> "%HISTORICO%"
    )

    timeout /t 2 >nul
)

if !COUNT! gtr 1 (
    echo.
    echo ======================================
    echo TOTAL DE VIDEOS BAIXADOS: !TOTAL! de !COUNT!
    echo ======================================
)

pause
goto :MENU

:UPDATE
cls
echo Atualizando yt-dlp...
"%YTDLP%" -U
pause
goto :MENU
