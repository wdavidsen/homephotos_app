import 'package:flutter/material.dart';
import 'package:homephotos_app/models/service_info.dart';
import 'package:homephotos_app/models/user_settings.dart';
import 'package:homephotos_app/services/user_settings_repository.dart';

class UserSettingsService {
  UserSettingsRepository userSettingsRepository;
  UserSettings _userSettings;

  UserSettingsService({
    this.userSettingsRepository
  }) {
    Future.wait([_loadSettings()]);
  }

  UserSettings getSettings() {
    return _userSettings;
  }

  Future saveSettings(UserSettings userSettings) async {
    try {
      await userSettingsRepository.update(userSettings);
      _userSettings = userSettings;
    }
    catch (e) {
      print("Failed to update user settings. " + e);
    }
  }

  Future updateCurrentServiceInfo(ServiceInfo serviceInfo) async {
    var settings = getSettings();
    settings.currentServiceUrl = serviceInfo.serviceUrl;
    await saveSettings(settings);
  }

  Future _loadSettings() async {

    try {
      _userSettings = await userSettingsRepository.get();
    }
    catch (e) {
      print("Failed to get user settings.");
      _userSettings = null;
    }

    if (_userSettings == null) {
      var defaultSettings = UserSettings(thumbnailSize: 'Medium', slideshowSpeed: 'Normal', autoStartSlideshow: false);
      await userSettingsRepository.insert(defaultSettings);
      _userSettings = defaultSettings;
    }
  }
}
