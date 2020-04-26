// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';


// AppState
class AppState {
  FirebaseUser _user;

  FirebaseUser get user => _user;

  AppState(this._user);
}


class UpdateUserAction{
  FirebaseUser _user;
  FirebaseUser get user => this._user;

  UpdateUserAction(this._user);
}



ThunkAction<AppState> getFirebaseUser = (Store<AppState> store) async{
  FirebaseAuth.instance.currentUser().then((u){
    print("getting user");
    print("User is $u");
    store.dispatch(new UpdateUserAction(u));
  });
};

// Reducer
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction){
    print("User");
    AppState newAppState = 
      new AppState(action.user);
    return newAppState;
  }
  else{
    return prev;
  }
}

// store that hold our current appstate
final store = new Store<AppState>(reducer,
    initialState: new AppState(null), middleware: [thunkMiddleware]);

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (_, state) {
                return new Text(
                  '${state.user}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20.0),
                );
              },
            ),
            StoreConnector<AppState, GenerateUser>(
              converter: (store) => () => store.dispatch(getFirebaseUser),
              builder: (_, generateUserCallback) {
                return new FlatButton(
                    color: Colors.lightBlue,
                    onPressed: generateUserCallback,
                    child: new Text("Get user"));
              },
            ),
          ],
        ),
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

typedef void GenerateUser(); // This is async.

// void main() => runApp(MaterialApp(
//   title: 'Navigation',
//   theme: ThemeData(
//     // Define the default brightness and colors.
//     primaryColor: Colors.white,
//     accentColor: Colors.red,
//     backgroundColor: Colors.white,
//     buttonColor: Color(0xFFFEF5350),
                        

//     // Define the default font family.
//     fontFamily: 'Roboto',

//     // Define the default TextTheme. Use this to specify the default
//     // text styling for headlines, titles, bodies of text, and more.
//     textTheme: TextTheme(
//       headline: TextStyle(fontSize: 60.0, color: Colors.red, fontWeight: FontWeight.bold),
//       title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//       body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//     ),
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

