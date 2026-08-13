import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Single source for the values that used to be read straight from `.env`.
///
/// Lookup order for every key:
///   1. Firebase Remote Config (so a value can be changed without a release)
///   2. the bundled `.env` (offline, first launch, or fetch failure)
///
/// SECURITY: Remote Config delivers values to the client in plaintext — they
/// can be read off the device or through the Remote Config REST API. It is a
/// configuration channel, not a secret store. Any key here that is genuinely
/// secret (the SendGrid / Stripe / Paystack secret keys) is exposed to anyone
/// who installs the app, exactly as it was when it shipped inside `.env`.
/// Moving them here did not change that. They should be rotated, and the
/// operations that use them moved behind the backend.
class AppConfig {
  AppConfig._();

  static FirebaseRemoteConfig? _remoteConfig;

  /// Keys mirrored into Remote Config. Kept here so the publish script and
  /// the app agree on the exact names.
  static const List<String> keys = <String>[
    'SENDGRILL_API_KEY',
    'SENDGRID_EMAIL_ADDRESS',
    'SENDGRID_TEMPLATE_ID',
    'SENDGRID_FORGOT_TEMPLATE_ID',
    'STRIPE_SEC_KEY',
    'STRIPE_PUB_KEY',
    'PAYSTACK_PUBLIC_KEY',
    'PAYSTACK_SECRET_KEY',
    'TEST_MONTHLY_PRICE',
    'TEST_YEARLY_PRICE',
  ];

  /// Fetches the live template. Safe to call before/without Remote Config
  /// being reachable — on any failure the app falls back to `.env`.
  static Future<void> init() async {
    try {
      final FirebaseRemoteConfig config = FirebaseRemoteConfig.instance;
      await config.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          // Values change rarely; an hour keeps startup cheap. Use
          // `forceRefresh()` after changing a parameter to pick it up sooner.
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      // Seed defaults from .env so the very first launch (before any fetch
      // completes) still resolves every key.
      await config.setDefaults(<String, dynamic>{
        for (final String key in keys) key: dotenv.env[key] ?? '',
      });
      await config.fetchAndActivate();
      _remoteConfig = config;
    } catch (e) {
      // Offline first launch, or Remote Config unavailable — .env still works.
      debugPrint('Remote Config unavailable, using .env values: $e');
      _remoteConfig = null;
    }
  }

  /// Re-fetches immediately, ignoring [minimumFetchInterval].
  static Future<void> forceRefresh() async {
    try {
      final FirebaseRemoteConfig? config = _remoteConfig;
      if (config == null) return;
      await config.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await config.fetchAndActivate();
    } catch (e) {
      debugPrint('Remote Config refresh failed: $e');
    }
  }

  /// Remote Config value for [key], falling back to `.env`.
  static String? get(String key) {
    final String? remote = _remoteConfig?.getString(key);
    if (remote != null && remote.isNotEmpty) return remote;
    return dotenv.env[key];
  }

  // Named accessors for the call sites, so key strings live in one place.
  static String? get sendgridApiKey => get('SENDGRILL_API_KEY');
  static String? get sendgridEmailAddress => get('SENDGRID_EMAIL_ADDRESS');
  static String? get sendgridTemplateId => get('SENDGRID_TEMPLATE_ID');
  static String? get sendgridForgotTemplateId =>
      get('SENDGRID_FORGOT_TEMPLATE_ID');
  static String? get monthlyPrice => get('TEST_MONTHLY_PRICE');
  static String? get yearlyPrice => get('TEST_YEARLY_PRICE');
}
