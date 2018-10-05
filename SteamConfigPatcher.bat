@echo off
title Steam Config Patcher
echo Welcome to the Steam Config Patcher!
echo This utility allows you to modify Steam client settings that are not available in the settings window.
echo.

if not exist sfk.exe (echo sfk.exe not found, make sure sfk.exe is in the same directory as this batch file! && pause && goto:eof)

echo Checking for Steam directory...
for /f "tokens=1,2*" %%E in ('reg query HKEY_CURRENT_USER\Software\Valve\Steam\') do if %%E==SteamPath set SteamPath=%%G

if exist "%SteamPath%" (echo Steam directory found! && echo.) else (echo Steam directory not found. && echo Confirm Steam is installed and try running this file as administrator. && pause && goto:eof)

echo Checking for write access to Steam directory...

mkdir "%SteamPath%/tmp"
if exist "%SteamPath%/tmp" (rmdir "%SteamPath%/tmp" && echo Success! && echo.) else (echo Write access denied, try running this file as administrator. && pause && goto:eof)

:start
echo Choose an option:
echo 1. Turn Friend Categorization By Game Off
echo 2. Turn Friend Categorization By Game On (Default)
echo 3. Turn Event And Announcement Notifications Off
echo 4. Turn Event and Announcement Notifications On (Default)
echo 5. Restart Steam for changes to take effect.
echo 6. Exit.
set /p choice=
if %choice%==1 goto:categorizeoff
if %choice%==2 goto:categorizeon
if %choice%==3 goto:eventnotificationsoff
if %choice%==4 goto:eventnotificationson
if %choice%==5 goto:restartsteam
if %choice%==6 goto:eof
echo Invalid selection, please try again.
goto:start 

:categorizeoff
sfk replace -dir "%SteamPath%/userdata" -file sharedconfig.vdf -pat "/bCategorizeInGameFriendsByGame\\\":true/bCategorizeInGameFriendsByGame\\\":false/" -yes -quiet
echo Friend categorization by game turned off!
echo.
goto:start

:categorizeon
sfk replace -dir "%SteamPath%/userdata" -file sharedconfig.vdf -pat "/bCategorizeInGameFriendsByGame\\\":false/bCategorizeInGameFriendsByGame\\\":true/" -yes -quiet
echo Friend categorization by game turned on!
echo.
goto:start

:eventnotificationsoff
sfk replace -dir "%SteamPath%/userdata" -file sharedconfig.vdf -pat "/bNotifications_EventsAndAnnouncements\\\":true/bNotifications_EventsAndAnnouncements\\\":false/" -yes -quiet
echo Event and Announcement notifications turned off!
echo.
goto:start

:eventnotificationson
sfk replace -dir "%SteamPath%/userdata" -file sharedconfig.vdf -pat "/bNotifications_EventsAndAnnouncements\\\":false/bNotifications_EventsAndAnnouncements\\\":true/" -yes -quiet
echo Event and Announcement notifications turned on!
echo.
goto:start

:restartsteam
echo Restarting Steam...
echo.
PSLIST steam >nul 2>&1
IF ERRORLEVEL 0 ( start /b /w " " "%SteamPath%/Steam.exe" -shutdown )
goto:LOOP

:startsteam
start /b " " "%SteamPath%/Steam.exe"
goto:start

:LOOP
PSLIST steam >nul 2>&1
IF ERRORLEVEL 1 (
  GOTO startsteam
) ELSE (
  TIMEOUT /T 3 >nul 2>&1
  GOTO LOOP
)