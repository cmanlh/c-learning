set projectName=RuntimeModifier
set programName=ScanMemory
mkdir .\output\%projectName%
gcc -g -o .\output\%projectName%\%programName%.exe .\src\%projectName%\%programName%.c .\lib\raylib\windows\libraylib.a -lgdi32 -lwinmm
.\output\%projectName%\%programName%.exe