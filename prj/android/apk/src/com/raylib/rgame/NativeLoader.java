package com.raylib.rgame; 
 
public class NativeLoader extends android.app.NativeActivity { 
    static { 
        System.loadLibrary("main");  
    } 
}