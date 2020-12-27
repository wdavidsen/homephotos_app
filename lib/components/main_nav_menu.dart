import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homephotos_app/blocs/auth-bloc.dart';
import 'package:homephotos_app/models/user.dart';

class MainNavMenu {

  static Widget build(BuildContext context) {
    final user = AuthBloc.getCurrentUser();

    return ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('${user.firstName} ${user.lastName}'),
            accountEmail: Text('${user.firstName}.${user.lastName}@gmail.com'),
            currentAccountPicture: CircleAvatar(backgroundImage: ExactAssetImage('assets/img/logo-sm.png'),
            ),
            //
            // otherAccountsPictures: <Widget>[
            //   CircleAvatar(
            //     child: Text('A'),
            //     backgroundColor: Colors.white60,
            //   ),
            //   CircleAvatar(
            //       child: Text('R')),
            // ],
            // onDetailsPressed: (){},
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage("assets/img/fundo.jpg"),
            //         fit: BoxFit.cover
            //     )
            // ),
          ),
          ListTile(
            title: Text('Profile'),
            leading: Icon(Icons.person),
            onTap: (){
              Navigator.of(context).pushNamed('/account');
            },
          ),
          allOptions(context, user),
          Divider(),
          ListTile(
              title: Text('Close'),
              leading: Icon(Icons.close),
              onTap: (){
                Navigator.of(context).pop();
              }
          ),
        ]
    );
  }

  static Column allOptions(BuildContext context, User user) {
    var list = options(context);

    if (user.role == 'Admin') {
      list.addAll(adminOptions(context));
    }
    return Column(
      children: list,
    );
  }

  static List<Widget> options(BuildContext context) {
    return [
      Divider(),
      ListTile(
        title: Text('Tags'),
        leading: Icon(Icons.label),
        onTap: (){
          Navigator.of(context).pushNamed('/tags');
        },
      ),
      ListTile(
        title: Text('Photos'),
        leading: Icon(Icons.photo),
        onTap: (){
          Navigator.of(context).pushNamed('/photos');
        },
      ),
      ListTile(
        title: Text('Upload'),
        leading: Icon(Icons.upload_file),
        onTap: (){
          Navigator.of(context).pushNamed('/upload');
        },
      ),
    ];
  }

  static List<Widget> adminOptions(BuildContext context) {
    return [
      Divider(),
      ListTile(
        title: Text('Settings'),
        leading: Icon(Icons.settings),
        onTap: (){
          Navigator.of(context).pushNamed('/settings');
        },
      ),
      ListTile(
        title: Text('Users'),
        leading: Icon(Icons.people),
        onTap: (){
          Navigator.of(context).pushNamed('/users');
        },
      ),
      ListTile(
        title: Text('Log'),
        leading: Icon(Icons.assignment_outlined),
        onTap: (){
          Navigator.of(context).pushNamed('/logs');
        },
      ),
    ];
  }
}