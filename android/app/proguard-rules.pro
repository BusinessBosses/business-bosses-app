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
