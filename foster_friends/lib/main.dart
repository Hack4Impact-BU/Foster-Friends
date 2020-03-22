// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import './login.dart';
import './landing.dart';
import './search.dart';
import './signup.dart'

void main() => runApp(MaterialApp(
  title: 'Navigation',
  theme: ThemeData(
    // Define the default brightness and colors.
    primaryColor: Colors.white,
    accentColor: Colors.red,
    backgroundColor: Colors.white,
    buttonColor: Colors.black,

    // Define the default font family.
    fontFamily: 'Roboto',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 60.0, color: Colors.red, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  ),


  initialRoute: '/',
  routes: {
    '/': (context) => MyApp(),
    '/LogIn': (BuildContext context) => new LogIn(),
    '/SignUp': (BuildContext context) => new SignUp(),
    '/Search': (BuildContext context) => new Search()
  }
));

