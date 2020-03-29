import 'package:flutter/material.dart';

// Unused 
class LogInEmail extends StatefulWidget {
  @override
  LogInEmailState createState() {
    return LogInEmailState();
  }
}

class LogInEmailState extends State<LogInEmail> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter your email',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          }),
      TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter your password',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          }),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Center(
              child: RaisedButton(
            color: Theme.of(context).buttonColor,
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                // If the form is valid, print valid on console
                print("Valid!");
              }
            },
            child: Text("Log In with Email",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).backgroundColor)),
          ))),
    ]);
  }
}
