import 'package:flutter/material.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';
import 'users_bloc.dart';

class UserForm extends StatefulWidget {
  UserForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  UsersBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of(context);
  }

  @override
  void initState() {
    // TODO: implement initState
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
        ]
    );
  }

  void saveSettings() {
    _bloc.submit().then((success) {
      if (success) {
        showErrorMessage('Account info saved');
      }
      else {
        showErrorMessage('Failed to save account info');
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