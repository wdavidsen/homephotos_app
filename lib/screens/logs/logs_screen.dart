import 'package:flutter/material.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/screens/logs/logs_bloc.dart';

import 'logs_form.dart';

class LogsScreen extends StatelessWidget {
  LogsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogsBloc>(
        bloc: LogsBloc(),
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
                    LogsForm()
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
