IF NOT EXIST output mkdir output
del /q output
copy source_rom\source.nes output\AD.nes
tools\xkas -o output/AD.nes src/main.asm
pause