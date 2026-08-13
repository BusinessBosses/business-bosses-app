import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [uri] without letting a hostile or broken handler crash the app.
///
/// `canLaunchUrl` only asks Android whether *some* activity claims the
/// scheme — it does not check whether that activity is actually launchable.
/// When the user's default handler for an https link is an app whose target
/// activity is not exported (we see this with several loan apps that register
/// broad web intent filters), the platform throws
/// `SecurityException: Permission Denial` and url_launcher rethrows it as a
/// PlatformException. Left uncaught that was the app's single biggest crash.
///
/// Falls back to an in-app WebView before giving up, so the user still gets
/// to the page when their default browser is unusable.
Future<bool> openUrl(
  Uri uri, {
  LaunchMode mode = LaunchMode.platformDefault,
  bool showErrorSnackbar = true,
  String? webOnlyWindowName,
}) async {
  try {
    if (await launchUrl(uri,
        mode: mode, webOnlyWindowName: webOnlyWindowName)) {
      return true;
    }
  } on PlatformException catch (e) {
    debugPrint('openUrl: platform refused $uri: ${e.code} ${e.message}');
  } catch (e) {
    debugPrint('openUrl: failed to open $uri: $e');
  }

  // Retry inside the app — this bypasses the broken external handler.
  if (mode != LaunchMode.inAppBrowserView &&
      (uri.scheme == 'http' || uri.scheme == 'https')) {
    try {
      if (await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
        return true;
      }
    } catch (e) {
      debugPrint('openUrl: in-app fallback failed for $uri: $e');
    }
  }

  if (showErrorSnackbar) {
    showSnackbar(
      title: 'Could not open link',
      message: 'No app on your device was able to open this link.',
      error: true,
    );
  }
  return false;
}

/// String convenience wrapper around [openUrl]. Returns false for input that
/// is not a valid URI rather than throwing.
Future<bool> openUrlString(
  String url, {
  LaunchMode mode = LaunchMode.platformDefault,
  bool showErrorSnackbar = true,
  String? webOnlyWindowName,
}) async {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null || uri.scheme.isEmpty) {
    debugPrint('openUrlString: not a usable URL: $url');
    if (showErrorSnackbar) {
      showSnackbar(
        title: 'Could not open link',
        message: 'That link does not look valid.',
        error: true,
      );
    }
    return false;
  }
  return openUrl(uri,
      mode: mode,
      showErrorSnackbar: showErrorSnackbar,
      webOnlyWindowName: webOnlyWindowName);
}
