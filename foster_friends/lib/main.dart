// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import './login_page.dart';
import './landing.dart';
import './search.dart';
import './form.dart';


import './uploadPet.dart';
import './org_profile.dart';
import './pet_profile.dart';
import './user_profile.dart';
import './edit_pet_profile.dart';
import './landing.dart';


void main() => runApp(MaterialApp(
  title: 'Navigation',
  theme: ThemeData(
    // Define the default brightness and colors.
    primaryColor: Colors.white,
    accentColor: Colors.red,
    backgroundColor: Colors.white,
    buttonColor: Color(0xFFFEF5350),
                        

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


  initialRoute: '/Search',
  routes: {
    '/': (context) => MyApp(),
    '/LogIn': (BuildContext context) => new LoginPage(),
    // '/Redirect': (BuildContext context) => new Redirect(auth: new Auth()),
    '/SignUp': (BuildContext context) => new InputForm(),
    '/Search': (BuildContext context) => new Search(),
    '/Form': (BuildContext context) => new InputForm(),
    '/UploadPet': (BuildContext context) => new UploadPet(),
    '/Org_Profile' : (BuildContext context) => new OrgProfile(),
    '/Pet_Profile' : (BuildContext context) => new PetProfile(),
    '/Edit_Pet_Profile' : (BuildContext context) => new EditPetProfile(),
    // '/User_Profile' : (BuildContext context) => new UserProfile(),
  }
));

