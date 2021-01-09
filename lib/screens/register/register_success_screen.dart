import 'package:flutter/material.dart';

class RegisterSuccessScreen extends StatelessWidget {
  RegisterSuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Registration Successful',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Thank you for registering! Please wait for an email from administrator, approving your account',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacementNamed("/login"),
              icon: Icon(Icons.login),
              label: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}