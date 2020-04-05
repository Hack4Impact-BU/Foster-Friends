import 'package:flutter/material.dart';
import 'package:foster_friends/authentication.dart';
import 'package:foster_friends/signup.dart';
import 'package:foster_friends/search.dart';

// Redirects user based on AuthStatus either to signup.dart or homepage

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class Redirect extends StatefulWidget {
  Redirect({this.auth});

  final BaseAuth auth;
  @override
  RedirectState createState() {
    return RedirectState();
  }
}

class RedirectState extends State<Redirect> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if(user != null) {
          _userId = user?.uid;
        }
        authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget build(BuildContext context) {
    switch(authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new SignUp(auth:widget.auth, loginCallback: loginCallback,);
        break;
      case AuthStatus.LOGGED_IN:
        if(_userId.length > 0 && _userId != null) {
          return new Search();
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
