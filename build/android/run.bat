set projectName=android
set programName=rGame
mkdir output\%projectName%
gcc -g -o output\%projectName%\%programName%.exe prj\android\src\screen_title.c prj\android\src\screen_options.c prj\android\src\screen_logo.c prj\android\src\raylib_game.c prj\android\src\screen_ending.c prj\android\src\screen_gameplay.c -Iinclude\raylib -Llib\raylib\windows -lraylib -lopengl32 -lgdi32 -lwinmm -std=c99 -Wall -mwindows
start output\%projectName%\%programName%.exe