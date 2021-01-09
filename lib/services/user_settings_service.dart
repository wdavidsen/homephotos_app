import 'package:homephotos_app/models/user_settings.dart';
import 'package:homephotos_app/services/user_settings_repository.dart';

class UserSettingsService {
  UserSettingsRepository userSettingsRepository;

  UserSettingsService({
    this.userSettingsRepository
  });

  Future<UserSettings> getSettings() async {
    var settings = await userSettingsRepository.get();

    if (settings == null) {
      var defaultSettings = UserSettings(thumbnailSize: 'Medium', slideshowSpeed: 'Normal', autoStartSlideshow: false);
      await userSettingsRepository.insert(defaultSettings);
      return defaultSettings;
    }
    return settings;
  }

  Future saveSettings(UserSettings userSettings) async {
    await userSettingsRepository.update(userSettings);
  }
}
