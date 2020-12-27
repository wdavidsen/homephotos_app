import 'package:get_it/get_it.dart';
import 'package:homephotos_app/bloc/bloc.dart';
import 'package:homephotos_app/data/user_settings_repository.dart';
import 'package:homephotos_app/models/user_settings.dart';

class PrefBloc extends Bloc {
  UserSettingsRepository _userSettingsRepository;

  Future<UserSettings> getUserSettings() async {
    _lazyInit();

    var settings = await _userSettingsRepository.get();

    if (settings == null) {
      var defaultSettings = UserSettings(thumbnailSize: 'Medium', slideshowSpeed: 'Normal', autoStartSlideshow: false);
      await _userSettingsRepository.insert(defaultSettings);
      return defaultSettings;
    }
    return settings;
  }

  Future saveSettings(UserSettings userSettings) async {
    _lazyInit();
    await _userSettingsRepository.update(userSettings);
  }

  _lazyInit() {
    if (_userSettingsRepository == null) {
      _userSettingsRepository = GetIt.I.get();
    }
  }
}