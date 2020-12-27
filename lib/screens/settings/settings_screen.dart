import 'package:flutter/material.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/screens/settings/settings_bloc.dart';
import 'package:homephotos_app/screens/settings/settings_form.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
        bloc: SettingsBloc(),
        child: Container(
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(title),
              ),
              body: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                    ),
                    children: <Widget>[
                      SettingsForm()
                    ],
                  )
              ),
            drawer: Drawer(
              child: MainNavMenu.build(context),
            ),
          ),
        )
    );
  }
}
