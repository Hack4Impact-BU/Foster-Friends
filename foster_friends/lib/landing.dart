import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Foster Friends',
        home: Container(
          // padding: EdgeInsets.,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 0.0),
                child: Center(
                    child: Text('Foster Friends',
                        style: TextStyle(
                            fontSize: 50,
                            decoration: TextDecoration.none))),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                    child: RaisedButton(
                        onPressed: () {
                          print("Pressed Log In");
                          Navigator.pushNamed(  context, '/LogIn');
                          },
                        child: Text("Log In",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                                )),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Center(
                      child: RaisedButton(
                          onPressed: () {print("Pressed Sign up");},
                          child: Text("Sign Up",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          ))),
            ],
          ),
        ));
  }
}