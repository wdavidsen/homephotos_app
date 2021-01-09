import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/app_config.dart';
import 'package:homephotos_app/init.dart';
import 'package:homephotos_app/routes.dart';
import 'package:homephotos_app/screens/login/login_form_screen.dart';
import 'package:homephotos_app/screens/settings/settings_form_screen.dart';
import 'package:homephotos_app/services/navigator_service.dart';
import 'package:homephotos_app/services/user_store_service.dart';
import 'package:homephotos_app/splash_screen.dart';
import 'package:homephotos_app/themes/style.dart';

import 'bloc/bloc-prov-tree.dart';
import 'bloc/bloc-prov.dart';
import 'blocs/pref-bloc.dart';

void main({String env}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.forEnvironment(env);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future _initFuture = Init.initialize();

  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: <BlocProvider>[
        BlocProvider<PrefBloc>(bloc: PrefBloc()),
      ],
      child: MaterialApp(
        title: 'ePhotoBox',
        theme: appTheme(),
        routes: routes,
        navigatorKey: NavigatorService.navigatorKey,
        home: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final UserStoreService _userStore = GetIt.I.get();
              if (_userStore.isLoggedIn()) {
                return SettingsFormScreen();
              }
              else {
                return LoginFormScreen();
              }
            }
            else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
