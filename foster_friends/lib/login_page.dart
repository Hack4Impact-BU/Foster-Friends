import 'package:flutter/material.dart';
import 'package:foster_friends/authentication.dart';
import 'package:foster_friends/email.dart';
import 'package:foster_friends/form.dart';
import 'package:foster_friends/formMethods.dart';

// Current default page, includes google, email, and gmail sign in

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('assets/logo.png')),
              SizedBox(height: 50),
              _gsignInButton(),
              SizedBox(height: 25),
              _esignInButton(),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: showErrorMessage())
            ],
          ),
        ),
      ),
    );
  }

  Widget _gsignInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().then((e) {
          print("Done with $e");

          if (e == '') {
            existsInDatabase().then((isFound) {
              if (!isFound) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => new InputForm()));
              }
            });
          }

          setState(() {
            _errorMessage = e;
          });
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _esignInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        print('Pressed Email');
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => new Email()));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.email, size: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Email',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
