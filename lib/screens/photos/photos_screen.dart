import 'package:flutter/material.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';

class PhotosScreen extends StatefulWidget {
  PhotosScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: MainNavMenu.build(context),
      ),
    );
  }
}