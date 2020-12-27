import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';

import 'login_bloc.dart';

class LoginForm extends StatefulWidget {

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  LoginBloc _bloc;
  String test;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          usernameField(),
          SizedBox(height: 8.0),
          passwordField(),
          SizedBox(height: 24.0),
          loginButton(),
          SizedBox(height: 8.0),
          registerLabel()
        ]
    );
  }

  Widget usernameField() {
    return StreamBuilder(
        stream: _bloc.username,
        builder: (context, snapshot) {
          return TextField(
            onChanged: _bloc.changeUsername,
            decoration: InputDecoration(
                hintText: 'Username',
                errorText: snapshot.error,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)
                ),
            ),
          );
        });
  }

  Widget passwordField() {
    return StreamBuilder(
        stream: _bloc.password,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _bloc.changePassword,
            autofocus: false,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Password',
                errorText: snapshot.error,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)
                ),
            ),
          );
        });
  }

  Widget loginButton() {
    return StreamBuilder(
        stream: _bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // if (!snapshot.hasData || snapshot.hasError) {
          //
          // }
          return button();
        });
  }

  Widget button() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: Colors.lightBlueAccent.shade100,
            elevation: 5.0,
            color: Colors.lightBlueAccent,
            child: MaterialButton(
              minWidth: 200.0,
              height: 42.0,
              onPressed: () {
                if (_bloc.validateFields()) {
                  authenticateUser();
                }
                else {
                  showErrorMessage('Invalid username/password');
                }
              },
              child: Text('Sign-In',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                ),
              ),
            )
        )
    );
  }

  Widget registerLabel() {
    return FlatButton(
        onPressed: () {},
        child: Text(
          'Register a new account',
          style: TextStyle(color: Colors.black54),
        )
    );
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);
    _bloc.submit().then((success) {
      if (success) {
        Navigator.of(context).pushNamed('/settings');
        // Navigator.of(context).pushReplacementNamed('/photos');
      }
      else {
        showErrorMessage('Login failed');
      }
    });
  }

  void showErrorMessage(String message) {
    final snackbar = SnackBar(
        content: Text(message),
        duration: new Duration(seconds: 2)
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}