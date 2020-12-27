import 'package:flutter/material.dart';
import 'package:homephotos_app/bloc/bloc-prov.dart';
import 'package:homephotos_app/screens/settings/settings_bloc.dart';

class SettingsForm extends StatefulWidget {
  SettingsForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  SettingsBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of(context);
    _bloc.load();
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
          indexPathField(),
          cacheFolderField(),
          mobileUploadsFolderField()
        ]
    );
  }

  Widget indexPathField() {
    return StreamBuilder(
      stream: _bloc.indexPath,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _bloc.changeIndexPath,
          decoration: InputDecoration(
            hintText: 'Photos folder',
            errorText: snapshot.error,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0)
            ),
          ),
        );
    });
  }

  Widget cacheFolderField() {
    return StreamBuilder(
      stream: _bloc.cacheFolder,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _bloc.changeCacheFolder,
          decoration: InputDecoration(
            hintText: 'Photo cache folder',
            errorText: snapshot.error,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0)
            ),
          ),
        );
    });
  }

  Widget mobileUploadsFolderField() {
    return StreamBuilder(
      stream: _bloc.mobileUploadsFolder,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _bloc.changeMobileUploadsFolder,
          decoration: InputDecoration(
            hintText: 'Mobile uploads folder',
            errorText: snapshot.error,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0)
            ),
          ),
        );
    });
  }

  Widget submitButton() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // if (!snapshot.hasData || snapshot.hasError) {
          //
          // }
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
                        saveSettings();
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
    });
  }

  void saveSettings() {
    _bloc.submit().then((success) {
      if (success) {
        showErrorMessage('Settings saved');
      }
      else {
        showErrorMessage('Failed to save settings');
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