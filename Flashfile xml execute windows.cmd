@echo off
echo adb devices > commands.txt
echo adb reboot-bootloader >> commands.txt
echo fastboot devices >> commands.txt
echo fastboot reboot-bootloader >> commands.txt
if exist flashfile.xml (
goto startconvert
) else (
goto noflashfilexml
)
:noflashfilexml
find "flashfile" flashfile.xml
pause
exit
:startconvert
findstr "\<software_version\>" flashfile.xml > software_version.txt
for /F delims^=^"^ Tokens^=2^* %%G in (software_version.txt) DO set title=%%G
title %title%
echo @title %title% > flashfile.cmd
echo mfastboot getvar max-sparse-size >> flashfile.cmd
echo mfastboot oem fb_mode_set >> flashfile.cmd
findstr "\<erase\>" flashfile.xml | findstr /v "modem" > erase.txt
findstr "\<flash\>" flashfile.xml > flash.txt
for /F delims^=^"^ Tokens^=4^,6^,8^* %%G in (flash.txt) DO @echo mfastboot %%H %%I %%G >> flashfile.cmd
for /F delims^=^"^ Tokens^=2^,4^,6^* %%G in (erase.txt) DO @echo mfastboot %%G %%H >> flashfile.cmd
echo mfastboot oem fb_mode_clear >> flashfile.cmd
echo mfastboot reboot >> flashfile.cmd
echo @cmd >> flashfile.cmd
del erase.txt
del flash.txt
del software_version.txt
if exist mfastboot.exe (
goto startflash
) else (
goto nomfastbootexe
)
:nomfastbootexe
copy flashfile.cmd "%title%.txt"
exit
:startflash
pause
echo on
cls
@flashfile.cmd
exit