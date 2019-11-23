@echo off
If not exist Tetri.asm echo File Does Not Exist
If not exist Tetri.asm goto end

If exist Tetri.obj erase Tetri.obj
If exist Tetri.exe erase Tetri.exe

masm Tetri /z /Zi /Zd /v ,Tetri ;
If not exist Tetri.obj goto end

link Tetri,Tetri,nul;
If not exist Tetri.exe goto end

Tetri.exe

:end