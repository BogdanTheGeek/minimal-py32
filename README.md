# Minimal Puya PY32 development environment

## Requirements:
 - make
 - arm-none-eabi-*
 - pyOCD with PY32 packs installed


## Commands:
 - `make` - build everything
 - `make flash` - flash firmware
 - `make connect` - connect to target with pyOCD
 - `make debug` - start gdb (must call connect in a different window first)
 - `make monitor` - open console via ARM semihosting

## Usage:
Set the desired microcontroller in the Makefile.

You can copy, or create a symlink to, any file in `/lib` into `/src`.

For anything else, use the reference manual.

## Acknowledgements:
 - [wagiminator](https://github.com/wagiminator/MCU-Templates)
