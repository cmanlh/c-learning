set projectName=RuntimeModifier
set programName=ScanMemory
mkdir output\%projectName%
gcc -g -o output\%projectName%\%programName%.exe prj\%projectName%\%programName%.c lib\raylib\windows\libraylib.a -lgdi32 -lwinmm
output\%projectName%\%programName%.exe