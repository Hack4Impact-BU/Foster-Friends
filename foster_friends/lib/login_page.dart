import 'package:flutter/material.dart';
import 'package:foster_friends/authentication.dart';
import 'package:foster_friends/google.dart';
import 'package:foster_friends/redirect.dart';
import 'package:foster_friends/search.dart';

// Current default page, includes google, email, and gmail sign in

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        print('Pressed');
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Search();
              },
            ),
          );
          print("Done");
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
            )
          ],
        ),
      ),
    );
  }

  Widget _esignInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        print('Pressed');

        // Navigator.pushNamed(context, '/');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    new Redirect(auth: new Auth())));
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
}
