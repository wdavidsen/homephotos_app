import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/services/homephotos_service.dart';
import 'package:homephotos_app/services/user_store_service.dart';

class MainNavMenu {

  static Widget build(BuildContext context) {
    final UserStoreService _userStore = GetIt.I.get();
    final user = _userStore.getCurrentUser();
    final HomePhotosService _homePhotosService = GetIt.I.get();

    return ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('${user.firstName} ${user.lastName}'),
            accountEmail: Text(user.emailAddress ?? ''),
            currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage('${_homePhotosService.getAvatarUrl()}/${user.avatarImage}'),
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