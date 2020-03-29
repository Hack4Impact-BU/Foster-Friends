import 'package:flutter/material.dart';
import './authentication.dart';

// Email login and sign up page

class SignUp extends StatefulWidget {
  SignUp({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  SignUpState createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;
  String _emailMatch;
  String _passMatch;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("hi");
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Foster Friends'),
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showEmailInput(),
              showConfirmEmailInput(),
              showPasswordInput(),
              showConfirmPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
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

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Enter your email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) {
            _isLoading = false;
            return 'Please enter your email';
          }
          RegExp email = new RegExp(".+@[^.]+\.[^.]{2,}"); // Must be a valid email address, including a prefix, @, and domain with one period.  
          if(!email.hasMatch(value)) {
            _isLoading = false;
            return "Must be a valid email address";
          }
          _emailMatch = value;
          return null;
        },
        onSaved: (value) {
          _email = value.trim();
        },
      ),
    );
  }

  Widget showConfirmEmailInput() {
    if(!_isLoginForm) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Confirm your email',
              icon: new Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          validator: (value) {
            if (_emailMatch.length > 0 && value.isEmpty) {
              _isLoading = false;
              return 'Please confirm your email';
            }
            if(_emailMatch.length > 0 && value != _emailMatch) {
                return 'Emails must match';
            }
              return null;
          },
          onSaved: (value) {
            _email = value.trim();
          },
        ),
      );
    }
    return SizedBox(height: 0);
  }  

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Enter your password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) {
            _isLoading = false;
            return 'Please enter your password';
          }
          int reqs = 5;
          int met = 0;
          RegExp lower = new RegExp(".*[a-z].*");
          RegExp upper = new RegExp(".*[A-Z].*");
          RegExp nums = new RegExp(".*[0-9].*");
          RegExp special = new RegExp(".*[\x21-\x2F\x3A-\x40\x5B-\x60\x7B-\x7E].*");
          if(value.length > 7) {
            met++;
          }
          if(lower.hasMatch(value)) {
            met++;
          }
          if(upper.hasMatch(value)) {
            met++;
          }
          if(nums.hasMatch(value)) {
            met++;
          }
          if(special.hasMatch(value)) {
            met++;
          }
          if(met != reqs) {
            _isLoading = false;
            return 'Password must be at least 8 characters, \n and include at least one upper case letter, \n lower case letter, number, and special character. \n' + (reqs - met).toString() + ' of the ' + reqs.toString() + ' requirements are unmet.';
          }
          _passMatch = value;
          return null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showConfirmPasswordInput() {
    if(!_isLoginForm) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Confirm your password',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) {
            if (_passMatch.length > 0 && value.isEmpty) {
              return 'Please confirm your password';
            }
            if(_passMatch.length > 0 && value != _passMatch) {
              return 'Passwords must match';
            }
            return null;
          },
          onSaved: (value) => _password = value.trim(),
        ),
      );
    }
    return SizedBox(height: 0);
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.red,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}