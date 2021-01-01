import 'package:flutter/material.dart';

class UsersFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
        child: Text("Navigate to user detail"),
        onPressed: () {
          // When the user taps the button, navigate to a named route
          // and provide the arguments as an optional parameter.
          Navigator.pushNamed(
            context,
            '/user-detail',
            arguments: 1
          );
        },
    );
  }
}