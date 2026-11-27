# Protect all model classes from obfuscation
-keep class com.example.storza.features.auth.data.models.** { *; }
-keep class com.example.storza.features.albums.data.models.** { *; }
-keep class com.example.storza.features.photos.data.models.** { *; }

# Keep Dio and GetX internal classes
-keepattributes Signature
-keepattributes *Annotation*
-keep class javax.annotation.** { *; }
-dontwarn okio.**
-dontwarn javax.annotation.**
