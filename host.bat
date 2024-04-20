@echo off

set gzdoom=".\..\gzdoom\gzdoom.exe"

%gzdoom% -file ..\multiplayer\nacht.zip -warp 01 -config ..\multiplayer\config.ini -host 2 %*