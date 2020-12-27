import 'package:flutter/material.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';

class TagsScreen extends StatefulWidget {
  TagsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {

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