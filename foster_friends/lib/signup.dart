import 'package:flutter/material.dart';

// Define a custom Form widget.
class SignUp extends StatefulWidget {
  @override
  SignUpState createState() {
    return SignUpState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SignUpState extends State<SignUp> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Scaffold(
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                            child: Text("Log In",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).backgroundColor)),
                          ))),

                      // Add TextFormFields and RaisedButton here.
                    ]))));
  }
}