import 'package:flutter/material.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/screens/account/account_bloc.dart';

import 'account_form.dart';

class AccountScreen extends StatelessWidget {
  final String title;

  AccountScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
        bloc: AccountBloc(),
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
                    AccountForm()
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
