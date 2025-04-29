@echo off
color 0D

title SEngine Dependencies


echo ====================================
echo     Welcome to SEngine Check Dependencies
echo ====================================
echo.

call :check_install lime
call :check_install openfl
call :check_install flixel
call :check_install flixel-addons
call :check_install flixel-ui
call :check_install flixel-tools
call :check_install SScript
call :check_install hxCodec
call :check_install tjson
call :check_install flxanimate
call :check_install linc_luajit
call :check_install hxdiscord_rpc
call :check_install hxWindowColorMode

echo ====================================
echo Dependencies Checked Successfully!
echo ====================================

pause
exit /b

:check_install
for /f "tokens=1,2 delims=: " %%A in ('haxelib list ^| findstr /i "^%1"') do (
    echo %%A is already installed. Version: %%B
    exit /b
)
echo Installing %1...
haxelib install %1
exit /b
