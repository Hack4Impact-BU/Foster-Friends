import 'package:flutter/material.dart';
import 'package:foster_friends/containers/authentication/login_page.dart';

class NoSignIn extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            child: Center(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(height: 40),
        Text(
          'You are not signed in',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => new LoginPage()));
          },
          color: Colors.deepPurple,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sign In',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        )
      ],
    ))));
  }
}
