import 'package:flutter/material.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';
import 'login_bloc.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        bloc: LoginBloc(),
        child: Container(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                    ),
                    children: <Widget>[
                      SizedBox(height: 48.0),
                      logo,
                      nameLabel,
                      SizedBox(height: 48.0),
                      LoginForm()
                    ],
                  )
              )
          ),
        )
    );
  }

  final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/img/logo-lg.png')
      )
  );

  final nameLabel = FlatButton(
      onPressed: () {},
      child: Text(
        'ePhotoBox',
        style: TextStyle(
            color: Colors.black87,
            fontSize: 20.0
        ),
      )
  );
}