import 'package:flutter/material.dart';
import 'package:foster_friends/google.dart';
import 'package:firebase_auth/firebase_auth.dart';

String photoUrl = '';
String displayName = '';
String email = '';

class BadProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    await _getUser(); // make wait
    print('User is: ' + displayName);

    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        //   colors: [Colors.blue[100], Colors.blue[400]],
        // ),
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     photoUrl,
              //   ),
              //   radius: 60,
              //   backgroundColor: Colors.transparent,
              // ),
              SizedBox(height: 40),
              Text(
                'NAME',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                displayName,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'EMAIL',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                email,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              RaisedButton(
                onPressed: () {
                  print('Pressed signout');
                  signOutGoogle();
                  Navigator.of(context).pushNamed('/');
                },
                color: Colors.deepPurple,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getUser() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      print('user ' + user.displayName.toString());
      displayName = user.displayName;
      photoUrl = user.photoUrl;
      email = user.email;
    });

    // await auth.currentUser().then((firebaseUser) {
    //   if(firebaseUser != null){
    //     displayName  =firebaseUser.displayName;
    //     photoUrl = firebaseUser.photoUrl;
    //     email = firebaseUser.email;
    //   }
    // });
  }
}
