import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[Text("Username"), Text("Text box")],
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[Text("Password"), Text("Text box")],
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(onPressed: () {}, child: Text("Log In"))),
          Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(onPressed: () {
                print("Going back to landing page");
                Navigator.pushNamed(context, '/');
              }, child: Text("Go Back")))
        ],
      ),
    );
  }
}
