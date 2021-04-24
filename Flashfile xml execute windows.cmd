@echo off
if exist flashfile.xml (
goto start
) else (
goto error
)
:error
find "\<software_version\>" flashfile.xml
pause
exit
:start
findstr "\<software_version\>" flashfile.xml > software_version.txt
for /F delims^=^"^ Tokens^=2^,4^,6^* %%G in (software_version.txt) DO @title %%G %%H
for /F delims^=^"^ Tokens^=2^,4^,6^* %%G in (software_version.txt) DO echo @title %%G %%H > flashfile.cmd
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
pause
echo on
cls
@flashfile.cmd
exit