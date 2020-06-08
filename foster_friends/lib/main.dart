// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:foster_friends/containers/profiles/organizations/org_profile.dart';
import 'package:foster_friends/containers/home.dart';
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
            '/': (context) => Home(),
            // '/LogIn': (BuildContext context) => new LoginPage(),
            // '/Redirect': (BuildContext context) => new Redirect(auth: new Auth()),
            // '/SignUp': (BuildContext context) => new InputForm(),
            // '/Form': (BuildContext context) => new InputForm(),
            // '/UploadPet': (BuildContext context) => new UploadPet(),
            // '/Org_Profile': (BuildContext context) => new OrgProfile(),
            // '/User_Profile' : (BuildContext context) => new UserProfile(),
            //'/': (context) => OrgProfile(),
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

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    //creating first curver near bottom left corner
    var firstControlPoint = new Offset(size.width / 7, size.height - 80);
    var firstEndPoint = new Offset(size.width / 2, size.height / 2);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    //creating second curver near center
    var secondControlPoint = Offset(size.width / 2, size.height / 5);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    //creating third curver near top right corner
    var thirdControlPoint = Offset(size.width - (size.width / 11), size.height / 5);
    var thirdEndPoint = Offset(size.width, 0.0);
    
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move to top right corner
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }
  
  

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}