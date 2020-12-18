import 'package:flutter/material.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';
import 'package:homephotos_app/blocs/auth-bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthBloc authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {

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

    final username = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
    );

    final password = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)
        ),
      ),
    );
    
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        color: Colors.lightBlueAccent,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () async {
            if (await authBloc.login('wdavidsen', 'Pass@123')) {
              Navigator.of(context).pushNamed('/photos');
            }
            else {

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

    final registerLabel = FlatButton(
      onPressed: () {},
      child: Text(
        'Register a new account',
        style: TextStyle(color: Colors.black54),
      )
    );

    return Scaffold(
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
                username,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                SizedBox(height: 8.0),
                registerLabel
              ],
            )
        )
    );
  }
}