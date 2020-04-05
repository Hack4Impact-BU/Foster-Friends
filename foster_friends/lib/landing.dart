import 'package:flutter/material.dart';

// Default landing page with buttons to different pages, currently unused

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Foster Friends',
        home: Container(
          color: Theme.of(context).backgroundColor,
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
                        style: Theme.of(context).textTheme.headline
                        // TextStyle(
                        //     fontSize: Theme.of(context).,
                        //     decoration: TextDecoration.none,
                        //     color: Theme.of(context).accentColor)
                            )
                            ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                    child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                        onPressed: () {
                          print("Pressed Log In");
                          Navigator.pushNamed(  context, '/LogIn');
                          },
                        
                        child: Text("Log In",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).backgroundColor)),
                                )),
              ),
              // Padding(
              //     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //     child: Center(
              //         child: RaisedButton(
              //           color: Theme.of(context).accentColor,
              //             onPressed: () {print("Pressed Sign up");},
              //             child: Text("Sign Up",
              //                 style: TextStyle(
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.bold,
              //                     color: Theme.of(context).backgroundColor)),
              //             ))),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                    child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                        onPressed: () {
                          print("Pressed Search");
                          Navigator.pushNamed(  context, '/Search');
                          },
                        
                        child: Text("Search",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).backgroundColor)),
                                ))),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                    child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                        onPressed: () {
                          print("Pressed Upload Pet");
                          Navigator.pushNamed(  context, '/UploadPet');
                          },
                        
                        child: Text("Upload Pet",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).backgroundColor)),
                                ))),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                    child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                        onPressed: () {
                          print("Pressed org");
                          Navigator.pushNamed(  context, '/Org_Profile');
                          },
                        
                        child: Text("Org Profile",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).backgroundColor)),
                                ))),
            ],
          ),
        ));
  }
}