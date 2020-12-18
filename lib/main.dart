import 'package:flutter/material.dart';
import 'package:homephotos_app/app_config.dart';
import 'package:homephotos_app/routes.dart';
import 'package:homephotos_app/screens/home/home_screen.dart';
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
        initialRoute: '/login',
        routes: routes,
      ),
    );
  }
}
