import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Initialize Remote Config defaults and check for updates.
  static Future<void> checkUpdate(BuildContext context) async {
    try {
      // Set Remote Config settings & defaults
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await _remoteConfig.setDefaults(<String, dynamic>{
        'min_required_version': '3.2.1',
        'latest_version': '3.2.1',
        'force_update': false,
        'update_url_android': 'https://play.google.com/store/apps/details?id=xyz.codexia.businessbosses',
        'update_url_ios': 'https://apps.apple.com/us/app/business-bosses-networking/id1569332982',
        'update_title': 'App Update Available',
        'update_message': 'A new version of Business Bosses is available. Please update to enjoy the latest features and performance improvements.',
      });

      // Fetch latest values from Firebase Remote Config
      await _remoteConfig.fetchAndActivate();

      // Read installed app version
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersionStr = packageInfo.version;

      final String minVersionStr = _remoteConfig.getString('min_required_version');
      final String latestVersionStr = _remoteConfig.getString('latest_version');
      final bool forceUpdateConfig = _remoteConfig.getBool('force_update');

      final bool isBelowMinVersion = _isVersionLower(currentVersionStr, minVersionStr);
      final bool isBelowLatestVersion = _isVersionLower(currentVersionStr, latestVersionStr);
      final bool isForceUpdate = forceUpdateConfig || isBelowMinVersion;

      if ((isBelowMinVersion || isBelowLatestVersion) && context.mounted) {
        _showUpdateDialog(
          context,
          isForceUpdate: isForceUpdate,
          title: _remoteConfig.getString('update_title'),
          message: _remoteConfig.getString('update_message'),
          updateUrl: Platform.isAndroid
              ? _remoteConfig.getString('update_url_android')
              : _remoteConfig.getString('update_url_ios'),
        );
      }
    } catch (e) {
      debugPrint('AppUpdateService error: $e');
    }
  }

  /// Compare semantic version strings e.g. "3.2.1" vs "3.2.0"
  static bool _isVersionLower(String current, String target) {
    try {
      final List<int> currentParts = _parseVersionParts(current);
      final List<int> targetParts = _parseVersionParts(target);

      final int maxLength = currentParts.length > targetParts.length
          ? currentParts.length
          : targetParts.length;

      for (int i = 0; i < maxLength; i++) {
        final int currentVal = i < currentParts.length ? currentParts[i] : 0;
        final int targetVal = i < targetParts.length ? targetParts[i] : 0;

        if (currentVal < targetVal) return true;
        if (currentVal > targetVal) return false;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  static List<int> _parseVersionParts(String version) {
    // Remove build metadata (e.g., "3.2.1+98" -> "3.2.1")
    final String clean = version.split('+').first;
    return clean
        .split('.')
        .map((String part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
  }

  /// Show modern update modal dialog
  static void _showUpdateDialog(
    BuildContext context, {
    required bool isForceUpdate,
    required String title,
    required String message,
    required String updateUrl,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: !isForceUpdate,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: !isForceUpdate,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: <Widget>[
                const Icon(Icons.system_update_outlined, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            actions: <Widget>[
              if (!isForceUpdate)
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Later',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final Uri uri = Uri.parse(updateUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text('Update Now'),
              ),
            ],
          ),
        );
      },
    );
  }
}
