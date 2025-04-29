@echo off
color 0a
cd ..
cd ..
echo BUILDING GAME FOR WINDOWS 32-BITS!
echo This may take up to 5-20 minutes depending on your computer.
echo Or 1-5 minutes if the game was already compilied.
haxelib run lime build windows -32 -release -D 32bits -D HXCPP_M32
echo.
echo done.
pause
pwd
explorer.exe export\32bit\windows\bin