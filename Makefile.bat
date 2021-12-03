@echo off
REM SDCC Makefile

echo Compiling with SDCC...
cd Output
sdcc -mstm8 --std-c99 ../main.c
echo.

echo Flashing with stm8flash...
stm8flash -c stlink -p stm8l152c6 -w main.ihx
echo.

pause