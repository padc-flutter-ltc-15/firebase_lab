import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

const String remoteConfigThemeColor = "theme_color";

class SocialRemoteConfig {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static final SocialRemoteConfig _singleton = SocialRemoteConfig._internal();

  void initializeRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
  }

  SocialRemoteConfig._internal() {
    initializeRemoteConfig();

    _remoteConfig.fetchAndActivate();
  }

  factory SocialRemoteConfig() {
    return _singleton;
  }

  MaterialColor getThemeColorFromRemoteConfig() {
    debugPrint("Remote Config Theme Color Value ======> ${_remoteConfig.getString(remoteConfigThemeColor)}");

    return MaterialColor(
      int.parse(_remoteConfig.getString(remoteConfigThemeColor)),
      const {},
    );
  }
}
