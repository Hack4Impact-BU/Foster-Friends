import 'package:flutter/material.dart';
import './authentication.dart';
class Home extends StatefulWidget {
  Home({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  HomeState createState() {
    return HomeState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class HomeState extends State<Home> {
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
        ),
    );
  }
}