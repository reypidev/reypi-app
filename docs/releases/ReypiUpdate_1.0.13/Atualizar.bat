@echo off
setlocal
title Reypi Relogio Ponto - Atualizacao

echo Encerrando o sistema...
taskkill /f /im RReypiRelogioPonto.exe >nul 2>&1
timeout /t 1 >nul

set APPDIR=C:\ReypiPonto
if not "%~1"=="" set "APPDIR=%~1"
if not exist "%APPDIR%\RReypiRelogioPonto.exe" (
  echo Pasta de instalacao nao encontrada: %APPDIR%
  echo Ajuste a variavel APPDIR neste .bat se for diferente.
  pause
  exit /b 1
)

rem Localiza o novo executavel no pacote (procura recursivamente a partir da pasta do BAT)
set "NEWEXE="
for /r "%~dp0" %%F in (RReypiRelogioPonto.exe) do (
  if /I not "%%~fF"=="%APPDIR%\RReypiRelogioPonto.exe" (
    if not defined NEWEXE set "NEWEXE=%%~fF"
  )
)

if not defined NEWEXE (
  echo Nao encontrei o novo executavel no pacote: RReypiRelogioPonto.exe
  echo Certifique-se de que o ZIP contem o executavel.
  pause
  exit /b 1
)

echo Copiando novo executavel...
copy /y "%NEWEXE%" "%APPDIR%\RReypiRelogioPonto_NEW.exe" >nul || (
  echo Falha ao copiar o novo executavel para %APPDIR%.
  pause
  exit /b 1
)

rem Procura o Updater.exe no pacote e faz fallback para o do APPDIR
set "UPDATER="
for /r "%~dp0" %%U in (Updater.exe) do (
  if not defined UPDATER set "UPDATER=%%~fU"
)
if not defined UPDATER if exist "%APPDIR%\Updater.exe" set "UPDATER=%APPDIR%\Updater.exe"

if defined UPDATER (
  echo Aplicando atualizacao com Updater.exe...
  "%UPDATER%" "%APPDIR%\RReypiRelogioPonto.exe" "%APPDIR%\RReypiRelogioPonto_NEW.exe"
) else (
  echo Updater.exe nao encontrado no pacote nem em %APPDIR%. Tentando substituicao simples...
  del /f /q "%APPDIR%\RReypiRelogioPonto.exe" >nul 2>&1
  move /y "%APPDIR%\RReypiRelogioPonto_NEW.exe" "%APPDIR%\RReypiRelogioPonto.exe" >nul
)

echo Iniciando o sistema pelo atalho...
set LINK="%ProgramData%\Microsoft\Windows\Start Menu\Programs\Reypi Relogio Ponto\Reypi Relogio Ponto.lnk"
if exist %LINK% (
  start "" %LINK%
) else (
  set DESKLINK="%Public%\Desktop\Reypi Relogio Ponto.lnk"
  if exist %DESKLINK% (
    start "" %DESKLINK%
  ) else (
    start "" "%APPDIR%\RReypiRelogioPonto.exe"
  )
)

exit /b 0


