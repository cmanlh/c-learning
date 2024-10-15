@REM 以下变量需根据实际情况进行调整

@REM Android project configuration variables
set PROJECT_NAME=rGame
set PROJECT_LIBRARY_NAME=main
set PROJECT_BUILD_ID=android
set PROJECT_SOURCE_FILES=raylib_game.c
set PROJECT_PACKAGE=com.raylib.rgame

@REM Define Android architecture (armeabi-v7a, arm64-v8a, x86, x86-64) and API version
set ANDROID_ARCH_NAME=arm64-v8a
set ANDROID_API_VERSION=33

@REM Required path variables
set JAVA_HOME=D:\jdk\jdk-13
set ANDROID_HOME=D:\android\sdk
set ANDROID_NDK=D:\android\ndk
set HEAD_INCLUDE_PATHS=include\raylib
set PROJECT_BUILD_PATH=output\%PROJECT_BUILD_ID%
set PROJECT_PATH=prj\android
set PROJECT_RESOURCES_PATH=%PROJECT_PATH%\src\resources

@REM Android app configuration variables
set APP_LABEL_NAME=rGame
set APP_COMPANY_NAME=raylib
set APP_PRODUCT_NAME=rgame
set APP_VERSION_CODE=1
set APP_VERSION_NAME=1.0
set APP_RESOURCE_PATH=%PROJECT_PATH%\apk\res
set APP_ICON_LDPI=%APP_RESOURCE_PATH%\icons\drawable-ldpi\icon.png
set APP_ICON_MDPI=%APP_RESOURCE_PATH%\icons\drawable-mdpi\icon.png
set APP_ICON_HDPI=%APP_RESOURCE_PATH%\icons\drawable-hdpi\icon.png
set APP_SCREEN_ORIENTATION=landscape
set APP_KEYSTORE_PASS=raylib

@REM android command tools
set ANDROID_TOOLCHAIN=%ANDROID_NDK%\toolchains\llvm\prebuilt\windows-x86_64
set ANDROID_BUILD_TOOLS=%ANDROID_HOME%\build-tools\33.0.3
set ANDROID_PLATFORM_TOOLS=%ANDROID_HOME%\platform-tools

@REM Compiler and archiver
set CC=%ANDROID_TOOLCHAIN%\bin\aarch64-linux-android%ANDROID_API_VERSION%-clang
set AR=%ANDROID_TOOLCHAIN%\bin\aarch64-linux-android-ar

@REM Compiler flags for arquitecture
set "CFLAGS= -std=c99 -march=armv8-a -mfix-cortex-a53-835769"
@REM Compilation functions attributes options
set "CFLAGS=%CFLAGS% -ffunction-sections -funwind-tables -fstack-protector-strong -fPIC"
@REM Compiler options for the linker
set "CFLAGS=%CFLAGS% -Wall -Wa,--noexecstack -Wformat -Werror=format-security -no-canonical-prefixes"

@REM Linker options
set "LDFLAGS= -Wl,-soname,lib%PROJECT_LIBRARY_NAME%.so -Wl,--exclude-libs,libatomic.a" 
set "LDFLAGS=%LDFLAGS% -Wl,--build-id -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--warn-shared-textrel -Wl,--fatal-warnings"
@REM Force linking of library module to define symbol
set "LDFLAGS=%LDFLAGS% -u ANativeActivity_onCreate"
@REM Library paths containing required libs
set "LDFLAGS=%LDFLAGS% -L. -L%PROJECT_BUILD_PATH%\obj -L%PROJECT_BUILD_PATH%\lib\%ANDROID_ARCH_NAME%"

@REM Define any libraries to link into executable
set "LDLIBS= -lm -lc -lraylib -llog -landroid -lEGL -lGLESv2 -lOpenSLES -ldl"

@REM prepare output directories
set PROJECT_BUILD_PATH_SRC=%PROJECT_BUILD_PATH%\src\%PROJECT_PACKAGE:.=\%
set PROJECT_BUILD_PATH_RES=%PROJECT_BUILD_PATH%\res
set PROJECT_BUILD_PATH_RESOURCE=%PROJECT_BUILD_PATH%\assets\resources
set PROJECT_BUILD_PATH_LIB=%PROJECT_BUILD_PATH%\lib
set PROJECT_BUILD_PATH_OBJ=%PROJECT_BUILD_PATH%\obj
set PROJECT_BUILD_PATH_BIN=%PROJECT_BUILD_PATH%\bin

rmdir /S /Q %PROJECT_BUILD_PATH%
mkdir %PROJECT_BUILD_PATH%
mkdir %PROJECT_BUILD_PATH_SRC%
mkdir %PROJECT_BUILD_PATH_RES%\values
mkdir %PROJECT_BUILD_PATH_RESOURCE%
mkdir %PROJECT_BUILD_PATH_OBJ%
mkdir %PROJECT_BUILD_PATH_LIB%\%ANDROID_ARCH_NAME%
mkdir %PROJECT_BUILD_PATH_BIN%

copy .\lib\raylib\%ANDROID_ARCH_NAME%\libraylib.a %PROJECT_BUILD_PATH_LIB%\%ANDROID_ARCH_NAME%\
copy %PROJECT_RESOURCES_PATH%\* %PROJECT_BUILD_PATH_RESOURCE%\
xcopy %APP_RESOURCE_PATH%\images %PROJECT_BUILD_PATH_RES% /S

@REM Generate strings.xml
echo ^<?xml version="1.0" encoding="utf-8"?^> > %PROJECT_BUILD_PATH_RES%\values\strings.xml
echo ^<resources^>^<string name="app_name"^>%APP_LABEL_NAME%^</string^>^</resources^> >> %PROJECT_BUILD_PATH_RES%\values\strings.xml

@REM Generate NativeLoader.java to load required shared libraries
echo package %PROJECT_PACKAGE%; > %PROJECT_BUILD_PATH_SRC%/NativeLoader.java
echo. >> %PROJECT_BUILD_PATH_SRC%/NativeLoader.java
echo public class NativeLoader extends android.app.NativeActivity { >> %PROJECT_BUILD_PATH_SRC%/NativeLoader.java
echo     static { >> %PROJECT_BUILD_PATH_SRC%/NativeLoader.java
echo         System.loadLibrary("%PROJECT_LIBRARY_NAME%"); >> %PROJECT_BUILD_PATH_SRC%/NativeLoader.java
echo     } >> %PROJECT_BUILD_PATH_SRC%/NativeLoader.java
echo } >> %PROJECT_BUILD_PATH_SRC%/NativeLoader.java

@REM Generate AndroidManifest.xml with all the required options
echo ^<?xml version="1.0" encoding="utf-8"^?^> > %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo ^<manifest xmlns:android="http://schemas.android.com/apk/res/android" >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo         package="%PROJECT_PACKAGE%"  >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo         android:versionCode="%APP_VERSION_CODE%" android:versionName="%APP_VERSION_NAME%" ^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo     ^<uses-sdk android:minSdkVersion="%ANDROID_API_VERSION%" /^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo     ^<uses-feature android:glEsVersion="0x00020000" android:required="true" /^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo     ^<application android:allowBackup="false" android:label="@string/app_name" android:icon="@drawable/icon" ^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo         ^<activity android:name="%PROJECT_PACKAGE%.NativeLoader" >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo             android:theme="@android:style/Theme.NoTitleBar.Fullscreen" >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo             android:configChanges="orientation|keyboard|keyboardHidden|screenSize" >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo             android:screenOrientation="%APP_SCREEN_ORIENTATION%" android:launchMode="singleTask" >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo             android:clearTaskOnLaunch="true" >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo             android:exported="true"^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo             ^<meta-data android:name="android.app.lib_name" android:value="%PROJECT_LIBRARY_NAME%" /^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo             ^<intent-filter^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo                 ^<action android:name="android.intent.action.MAIN" /^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo                 ^<category android:name="android.intent.category.LAUNCHER" /^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo             ^</intent-filter^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo         ^</activity^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo     ^</application^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml
echo ^</manifest^> >> %PROJECT_BUILD_PATH%/AndroidManifest.xml

@REM Config project package and resource using AndroidManifest.xml and res/values/strings.xml
@REM NOTE: Generates resources file: %PROJECT_BUILD_PATH_SRC%/R.java
%ANDROID_BUILD_TOOLS%\aapt package -f -m -S %PROJECT_BUILD_PATH_RES% -J %PROJECT_BUILD_PATH%\src -M %PROJECT_BUILD_PATH%\AndroidManifest.xml -I %ANDROID_HOME%\platforms\android-%ANDROID_API_VERSION%\android.jar

for %%F in (%PROJECT_PATH%\src\*.c) do (
    call %CC% -c %%F -o %PROJECT_BUILD_PATH_OBJ%\%%~nF.o -I. -I%HEAD_INCLUDE_PATHS% %CFLAGS% --sysroot=%ANDROID_TOOLCHAIN%\sysroot
)

@REM Compile project code into a shared library: lib/lib$(PROJECT_LIBRARY_NAME).so 
call %CC% -o %PROJECT_BUILD_PATH_LIB%\%ANDROID_ARCH_NAME%\lib%PROJECT_LIBRARY_NAME%.so output\android\obj\raylib_game.o output\android\obj\screen_ending.o output\android\obj\screen_gameplay.o output\android\obj\screen_logo.o output\android\obj\screen_options.o output\android\obj\screen_title.o -shared -I. -I%HEAD_INCLUDE_PATHS% %LDFLAGS% %LDLIBS%

%JAVA_HOME%/bin/javac -verbose --source 11 --target 11 -d %PROJECT_BUILD_PATH%\obj --system %JAVA_HOME% --class-path %ANDROID_HOME%\platforms\android-%ANDROID_API_VERSION%\android.jar;%PROJECT_BUILD_PATH%\obj --source-path %PROJECT_BUILD_PATH%\src %PROJECT_BUILD_PATH_SRC%\NativeLoader.java %PROJECT_BUILD_PATH_SRC%\R.java

call %ANDROID_BUILD_TOOLS%\d8 %PROJECT_BUILD_PATH%\obj\%PROJECT_PACKAGE:.=\%\*.class --release --output %PROJECT_BUILD_PATH%\bin --lib %ANDROID_HOME%\platforms\android-%ANDROID_API_VERSION%\android.jar

%ANDROID_BUILD_TOOLS%\aapt package -f -M %PROJECT_BUILD_PATH%\AndroidManifest.xml -S %PROJECT_BUILD_PATH%\res -A %PROJECT_BUILD_PATH%\assets -I %ANDROID_HOME%\platforms\android-%ANDROID_API_VERSION%\android.jar -F %PROJECT_BUILD_PATH%\bin\%PROJECT_NAME%.unaligned.apk %PROJECT_BUILD_PATH%\bin

cd %PROJECT_BUILD_PATH%
%ANDROID_BUILD_TOOLS%\aapt add bin\%PROJECT_NAME%.unaligned.apk lib/%ANDROID_ARCH_NAME%/lib%PROJECT_LIBRARY_NAME%.so

%ANDROID_BUILD_TOOLS%\zipalign -p -f 4 bin\%PROJECT_NAME%.unaligned.apk bin\%PROJECT_NAME%.aligned.apk

cd ..\..
%JAVA_HOME%/bin/keytool -genkeypair -validity 10000 -dname "CN=%APP_COMPANY_NAME%,O=Android,C=ES" -keystore %PROJECT_BUILD_PATH%\%PROJECT_NAME%.keystore -storepass %APP_KEYSTORE_PASS% -keypass %APP_KEYSTORE_PASS% -alias %PROJECT_NAME%Key -keyalg RSA

%ANDROID_BUILD_TOOLS%\apksigner sign --ks %PROJECT_BUILD_PATH%\%PROJECT_NAME%.keystore --ks-pass pass:%APP_KEYSTORE_PASS% --key-pass pass:%APP_KEYSTORE_PASS% --out %PROJECT_BUILD_PATH%\%PROJECT_NAME%.apk --ks-key-alias %PROJECT_NAME%Key %PROJECT_BUILD_PATH%\bin\%PROJECT_NAME%.aligned.apk

echo "hel"