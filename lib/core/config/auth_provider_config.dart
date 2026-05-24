import 'package:flutter/foundation.dart';

enum SocialAuthProvider { google, apple, facebook }

const List<SocialAuthProvider> enabledSocialProviders = [
  SocialAuthProvider.google,
  SocialAuthProvider.apple,
  SocialAuthProvider.facebook,
];

/// Helper class to manage authentication provider configuration.
class AuthProviderConfig {
  /// Returns whether a specific social auth provider is visible/enabled on the current platform.
  ///
  /// Asymmetric platform policy:
  /// - Google works on iOS, Android
  /// - Facebook works on iOS, Android
  /// - Apple Sign-In is required on iOS (Apple platforms) only and must be hidden elsewhere.
  static bool isProviderEnabled(SocialAuthProvider provider) {
    if (!enabledSocialProviders.contains(provider)) {
      return false;
    }

    switch (provider) {
      case SocialAuthProvider.google:
      case SocialAuthProvider.facebook:
        return true;
      case SocialAuthProvider.apple:
        // Apple Sign-In is only enabled on iOS/macOS.
        return defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS;
    }
  }

  /// Returns the list of visible providers on the current platform.
  static List<SocialAuthProvider> getVisibleProviders() {
    return SocialAuthProvider.values
        .where((provider) => isProviderEnabled(provider))
        .toList();
  }
}
