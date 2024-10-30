set projectName=opengl
set programName=start
mkdir output\%projectName%
gcc -g -o output\%projectName%\%programName%.exe prj\%projectName%\src\%programName%.c -Iprj\%projectName%\src\glfw\include\ -Iprj\%projectName%\src\glfw\deps\ prj\%projectName%\lib\libglfw3.a -std=c99 -Wall -lgdi32
output\%projectName%\%programName%.exe