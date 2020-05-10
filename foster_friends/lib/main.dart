// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:foster_friends/containers/search.dart';

void main() => runApp(new MyApp());

ThemeData t = ThemeData(
    // Define the default brightness and colors.
    primaryColor: Colors.white,
    accentColor: Colors.red,
    backgroundColor: Colors.white,
    buttonColor: Color(0xFFFEF5350),
    fontFamily: 'Roboto',
      
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
          title: 'Foster Friends',
          theme: t,
          initialRoute: '/',
          routes: {
            '/': (context) => Search(),
            // '/LogIn': (BuildContext context) => new LoginPage(),
            // '/Redirect': (BuildContext context) => new Redirect(auth: new Auth()),
            // '/SignUp': (BuildContext context) => new InputForm(),
            // '/Form': (BuildContext context) => new InputForm(),
            // '/UploadPet': (BuildContext context) => new UploadPet(),
            // '/Org_Profile': (BuildContext context) => new OrgProfile(),
            // '/Pet_Profile': (BuildContext context) => new PetProfile(),
            // '/User_Profile' : (BuildContext context) => new UserProfile(),
            // '/Edit_User_Profile' : (BuildContext context) => new EditUserProfile(),
          }),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: new Center(
//         child: new Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             StoreConnector<AppState, AppState>(
//               converter: (store) => store.state,
//               builder: (_, state) {
//                 return new Text(
//                   '${state.user}',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20.0),
//                 );
//               },
//             ),
            // StoreConnector<AppState, GenerateUser>(
            //   converter: (store) => () => store.dispatch(getFirebaseUser),
            //   builder: (_, generateUserCallback) {
            //     return new FlatButton(
            //         color: Colors.lightBlue,
            //         onPressed: generateUserCallback,
            //         child: new Text("Get user"));
            //   },
            // ),
//           ],
//         ),
//       ),
//  // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// void main() => runApp(MaterialApp(
//   title: 'Navigation',

//   ),

//   initialRoute: '/Search',
//   routes: {
//     '/': (context) => MyApp(),
//     '/LogIn': (BuildContext context) => new LoginPage(),
//     // '/Redirect': (BuildContext context) => new Redirect(auth: new Auth()),
//     '/SignUp': (BuildContext context) => new InputForm(),
//     '/Search': (BuildContext context) => new Search(),
//     '/Form': (BuildContext context) => new InputForm(),
//     '/UploadPet': (BuildContext context) => new UploadPet(),
//     '/Org_Profile' : (BuildContext context) => new OrgProfile(),
//     '/Pet_Profile' : (BuildContext context) => new PetProfile(),
//     // '/User_Profile' : (BuildContext context) => new UserProfile(),
//   }
// ));
