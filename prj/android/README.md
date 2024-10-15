**感谢项目[raylib game template](https://github.com/raysan5/raylib-game-template)中[makefile](build/Makefile.Android)记录的纯命令行打包发布apk的方法，才有了下面的定制版**

**记录不使用Android Studio集成环境的情况下，打包发布apk**

### 操作步骤
* 安装Android SDK Command Tools
* 使用sdkmanager安装相应版本build-tools, platform-tools, platforms, ndk组件
* 准备定义文件[strings.xml](android/res/values/strings.xml)
  * 定义变量Application Name : _app_name_
* 准备[icon文件](android/res/icons)
* 准备[java加载文件](android/src/cn/luh/apk/NativeLoader.java)
   * 注意需将包名调整为实际的项目对应包名
* 准备配置文件[AndroidManifest.xml](android/AndroidManifest.xml)
* 编译生成配置类R.java
   * \$(ANDROID_BUILD_TOOLS)/aapt package -f -m -S \$(PROJECT_BUILD_PATH)/res -J \$(PROJECT_BUILD_PATH)/src -M \$(PROJECT_BUILD_PATH)/AndroidManifest.xml -I \$(ANDROID_HOME)/platforms/android-$(ANDROID_API_VERSION)/android.jar
* 将项目源文件编译为a shared library
*  编译java文件
*  将class文件打包为dex文件
*  打包成apk
*  签名
    * 如无签名用的证书，可以使用jdk自带的keytool生成证书

### 最后，当然可以使用[自动脚本](../../build/apk/pac.bat)一键搞定