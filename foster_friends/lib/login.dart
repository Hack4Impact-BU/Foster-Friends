import 'package:flutter/material.dart';
import './loginEmail.dart';

// Define a custom Form widget.
class LogIn extends StatefulWidget {
  @override
  LogInState createState() {
    return LogInState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
        child: Scaffold(
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LogInEmail(),
                      Padding(padding: EdgeInsets.all(10),
                       child: Text( "OR")),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Center(
                              child: RaisedButton(
                            color: Theme.of(context).buttonColor,
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                            },
                            child: Text("Log In with Gmail",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).backgroundColor)),
                          )))
                    ]))));
  }
}
