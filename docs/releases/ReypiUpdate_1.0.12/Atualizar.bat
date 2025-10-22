@echo off
setlocal
title Reypi Relogio Ponto - Atualizacao

echo Encerrando o sistema...
taskkill /f /im RReypiRelogioPonto.exe >nul 2>&1
timeout /t 1 >nul

set APPDIR=C:\ReypiPonto
if not exist "%APPDIR%\RReypiRelogioPonto.exe" (
  echo Pasta de instalacao nao encontrada: %APPDIR%
  echo Ajuste a variavel APPDIR neste .bat se for diferente.
  pause
  exit /b 1
)

echo Copiando novo executavel...
copy /y "%~dp0RReypiRelogioPonto.exe" "%APPDIR%\RReypiRelogioPonto_NEW.exe" >nul

set UPDATER="%~dp0Updater.exe"
if exist %UPDATER% (
  echo Aplicando atualizacao com Updater.exe...
  %UPDATER% "%APPDIR%\RReypiRelogioPonto.exe" "%APPDIR%\RReypiRelogioPonto_NEW.exe"
) else (
  echo Updater.exe nao encontrado no pacote. Tentando substituicao simples...
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


