@echo off
color 0a
cd ..
setlocal

set "VS_DOWNLOAD_URL=https://download.visualstudio.microsoft.com/download/pr/3105fcfe-e771-41d6-9a1c-fc971e7d03a7/8eb13958dc429a6e6f7e0d6704d43a55f18d02a253608351b6bf6723ffdaf24e/vs_Community.exe"
set "VS_INSTALLER=vs_Community.exe"

echo Installing Microsoft Visual Studio Community (Dependency)

echo Downloading Visual Studio installer...
curl -# -O "%VS_DOWNLOAD_URL%"
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to download Visual Studio installer.
    pause
    exit /b 1
)

echo Running Visual Studio installer...
"%VS_INSTALLER%" --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 -passive
if %ERRORLEVEL% NEQ 0 (
    echo Error: Visual Studio installation failed.
    del "%VS_INSTALLER%"
    pause
    exit /b 1
)

echo Cleaning up...
del "%VS_INSTALLER%"
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Failed to delete the installer file.
)

echo Finished successfully.
pause
endlocal
