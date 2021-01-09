import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/user_settings.dart';
import 'package:sembast/sembast.dart';

class UserSettingsRepository {
  Database _database;
  StoreRef _store;

  UserSettingsRepository() {
    _database = GetIt.I.get();
    _store = intMapStoreFactory.store("user_settings");
  }

  Future<UserSettings> get() async {
    var snapshot = await _store.findFirst(_database);

    if (snapshot == null) {
      return null;
    }
    return UserSettings.fromJson(snapshot.value);
  }

  Future insert(UserSettings userSettings) async {
    if (await this.get() != null) {
      throw 'User settings already established. Use the update method instead.';
    }
    return await _store.add(_database, userSettings.toJson());
  }

  Future update(UserSettings userSettings) async {
    return await _store.update(_database, userSettings.toJson());
  }
}