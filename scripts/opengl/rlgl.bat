set projectName=opengl
set programName=rlgl
mkdir output\%projectName%
gcc -g -o output\%projectName%\%programName%.exe prj\%projectName%\src\%programName%.c -Iinclude\raylib\ -Llib\raylib\windows\ -lraylib -lopengl32 -lgdi32 -lwinmm -std=c99 -Wall -mwindows
output\%projectName%\%programName%.exe