# Flutter-specific ProGuard rules
# Keep Flutter engine classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep platform channels
-keep class com.vedica.labs.ind.app.tappico.** { *; }

# Keep generated plugin registrants
-keep class com.vedica.labs.ind.app.tappico.GeneratedPluginRegistrant { *; }

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Keep crash reporting
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Optimize: remove unused classes
-dontwarn java.lang.invoke.**
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# Google Play Core library - keep missing classes for R8
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**