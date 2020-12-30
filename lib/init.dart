import 'package:get_it/get_it.dart';
import 'package:homephotos_app/data/user_settings_repository.dart';
import 'package:homephotos_app/services/home_photos_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class Init {
  static Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }

  static _registerServices() async {
    print("starting loading services");
    await _initSembast();
    _registerRepositories();
    _initApiClients();
    print("finished loading services");
  }

  static _loadSettings() async {
    print("starting loading settings");
    await Future.delayed(Duration(seconds: 5));
    print("finished loading settings");
  }

  static Future _initSembast() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "ePhotoBox.db");
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }

  static void _initApiClients() {
    GetIt.I.registerSingleton<HomePhotosService>(HomePhotosService());
  }

  static _registerRepositories(){
    GetIt.I.registerLazySingleton<UserSettingsRepository>(() => UserSettingsRepository());
  }
}