set projectName=RuntimeModifier
set programName=testRuntime
mkdir .\output\%projectName%
gcc -g -o .\output\%projectName%\%programName%.exe .\src\%projectName%\%programName%.c .\lib\raylib\libraylib.a -lgdi32 -lwinmm
.\output\%projectName%\%programName%.exe