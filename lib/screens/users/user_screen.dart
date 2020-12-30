import 'package:flutter/material.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/screens/users/users_bloc.dart';

import 'user_form.dart';

class UserScreen extends StatelessWidget {
  UserScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersBloc>(
        bloc: UsersBloc(),
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
                    UserForm()
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
