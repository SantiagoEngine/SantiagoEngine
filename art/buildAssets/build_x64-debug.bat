@echo off
color 0a
cd ..
cd ..
echo BUILDING GAME FOR WINDOWS 64-BITS [DEBUG]!
echo This may take up to 5-20 minutes depending on your computer.
echo Or 1-5 minutes if the game was already compilied.
haxelib run lime build windows -debug
echo.
echo done.
pause
pwd
explorer.exe export\debug\windows\bin