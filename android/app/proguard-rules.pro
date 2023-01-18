-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }
-keep class androidx.appcompat.** { *; }
#
#-keepattributes Signature
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class com.google.firebase.** { *; }
-keepattributes JavascriptInterface
-keepattributes Annotation
-optimizations !method/inlining/
-keepclasseswithmembers class * {*;}
-dontwarn io.flutter.embedding.**