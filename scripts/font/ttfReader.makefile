shell= cmd

PROJECT_PATH					=C:\git\c-learning\prj\font
PROJECT_OUTPUT					=C:\git\c-learning\output\font
PROJECT_SRC						=$(PROJECT_PATH)\src
PROJECT_RELEASE					=$(PROJECT_OUTPUT)\release
PROJECT_BUILD_PATH				=$(PROJECT_OUTPUT)\build
PROJECT_BUILD_OBJ				=$(PROJECT_OUTPUT)\obj

BUILD_FLAG_INCLUDE				=-I$(PROJECT_SRC) -IC:\git\c-learning\include\raylib
BUILD_FLAG_LOADLIB				=-LC:\git\c-learning\lib\raylib\windows

COMPILE_FLAG					=$(BUILD_FLAG_INCLUDE) $(BUILD_FLAG_LOADLIB) -lraylib -lopengl32 -lgdi32 -lwinmm -std=c99 -Wall

all: reset run

reset:
	if exist $(PROJECT_BUILD_PATH) rd /S /Q $(PROJECT_BUILD_PATH)
	if not exist $(PROJECT_BUILD_OBJ) mkdir $(PROJECT_BUILD_OBJ)
	if exist $(PROJECT_RELEASE) rd /S /Q $(PROJECT_RELEASE)
	if not exist $(PROJECT_RELEASE) mkdir $(PROJECT_RELEASE)

resource_copy:
	xcopy $(PROJECT_SRC)\resources $(PROJECT_RELEASE)\resources /E /I

run: resource_copy
	gcc -o $(PROJECT_RELEASE)\ttfReader.exe $(PROJECT_SRC)\ttfReader.c $(COMPILE_FLAG)
	call start /D $(PROJECT_RELEASE) C:\git\c-learning\scripts\run.bat $(PROJECT_RELEASE)\ttfReader.exe