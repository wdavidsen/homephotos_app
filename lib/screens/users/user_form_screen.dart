import 'package:flutter/material.dart';

class UserFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final int photoId = ModalRoute.of(context).settings.arguments;

    print('photo id: ${photoId}');

    return Column();
  }
}