-keep class **.zego.** { *; }
-keep class **.**.zego_zpns.** { *; }
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# Stripe Push Provisioning – automatically generated keep rules
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# AndroidX Window & Sidecar rules for R8
-dontwarn androidx.window.extensions.**
-dontwarn androidx.window.sidecar.**

# Preserve native JNI methods (prevents UnsatisfiedLinkError)
-keepclasseswithmembernames class * {
    native <methods>;
}

# AndroidX DataStore & Protobuf JNI bindings
-keep class androidx.datastore.** { *; }
-dontwarn androidx.datastore.**
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

# Firebase SDKs
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
