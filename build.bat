@echo off
echo Packing files...

set extension-name="pixeqla-export-tags"

REM Get current directory name
for %%I in (.) do set DIRNAME=%%~nxI

REM Pack into .zip file (includes all .lua files, .png, .ase files and package.json)
powershell -Command "Compress-Archive -Path '*.lua','*.png','*.ase','package.json' -DestinationPath '%extension-name%.zip' -Force"

REM Delete old .aseprite-extension file
if exist "%extension-name%.aseprite-extension" del "%extension-name%.aseprite-extension"

REM Rename to .aseprite-extension
ren "%extension-name%.zip" "%extension-name%.aseprite-extension"

echo Build complete: %extension-name%.aseprite-extension
