@echo off
REM SDCC Makefile

echo Compiling with SDCC...
sdcc -mstm8 --std-c99 main.c -o Output\
echo.

pause