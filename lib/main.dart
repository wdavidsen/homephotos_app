import 'package:flutter/material.dart';
import 'package:homephotos_app/app_config.dart';
import 'package:homephotos_app/init.dart';
import 'package:homephotos_app/routes.dart';
import 'package:homephotos_app/screens/login/login1_screen.dart';
import 'package:homephotos_app/screens/login/login2_screen.dart';
import 'package:homephotos_app/screens/login/login_screen.dart';
import 'package:homephotos_app/splash_screen.dart';
import 'package:homephotos_app/themes/style.dart';

import 'bloc/bloc-prov-tree.dart';
import 'bloc/bloc-prov.dart';
import 'blocs/auth-bloc.dart';
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
        BlocProvider<AuthBloc>(bloc: AuthBloc()),
        BlocProvider<PrefBloc>(bloc: PrefBloc()),
      ],
      child: MaterialApp(
        title: 'ePhotoBox',
        theme: appTheme(),
        routes: routes,
        home: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done){
              return Login1Screen();
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
