// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
                            color: Colors.red,
                            decoration: TextDecoration.none))),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                    child: RaisedButton(
                        onPressed: () {print("Pressed Log In");},
                        child: Text("Log In",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        color: Colors.black)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Center(
                      child: RaisedButton(
                          onPressed: () {print("Pressed Sign up");},
                          child: Text("Sign Up",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.red))),
            ],
          ),
          color: Colors.white,
        ));
  }
}
