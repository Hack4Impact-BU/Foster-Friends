import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_friends/database.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/state/appState.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';


// Email login and sign up page

class InputForm extends StatefulWidget {
  @override
  InputFormState createState() => InputFormState();
}

class InputFormState extends State<InputForm> {
  final _formKey = new GlobalKey<FormState>();

  TextStyle s = TextStyle(color: Colors.white);
  Color pressed = Colors.red;
  Color notPressed = Colors.grey;

  String _name;

  String _phone;
  String _address;
  String _description;
  String _photo;

  String _errorMessage;

  bool isIndividual;
  bool _isLoading;

  // text form field
  final name = TextEditingController();
  final phone = TextEditingController();
  final description = TextEditingController();
  final address = TextEditingController();
  var photo;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    _photo = fileName;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  }
  
  // Perform login or signup

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    isIndividual = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      isIndividual = !isIndividual;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("hi");
    var validateAndSubmit;
    if (isIndividual == true) {
      if (name.text!="" && phone.text!="" && photo!=null) {
        validateAndSubmit = () async {
          uploadPic(context);
          setState(() {
            _errorMessage = "";
            _isLoading = true;
          });
          if (validateAndSave()) {
            FirebaseUser user = await getCurrentUser();
            try {
              await pushProfile(user.uid, _phone, user.email, _address, _name, _address, 
              _description, _photo, isIndividual);
              
              store.dispatch(getFirebaseUser);
              
              Navigator.pop(context);

              setState(() {
                _isLoading = false;
              });
            } catch (e) {
              print('Error: $e');
              setState(() {
                _isLoading = false;
                _errorMessage = e.message;
                _formKey.currentState.reset();
              });
            }
          }
        };
      }
    }
    else {
      if (name.text!="" && description.text!="" && phone.text!="" && address.text!="" && photo!=null) {
        validateAndSubmit = () async {
          uploadPic(context);
          setState(() {
            _errorMessage = "";
            _isLoading = true;
          });
          if (validateAndSave()) {
            FirebaseUser user = await getCurrentUser();
            try {
              await pushProfile(user.uid, _phone, user.email, _address, _name, _address, 
              _description, _photo, isIndividual);
              
              store.dispatch(getFirebaseUser);
              
              Navigator.pop(context);

              setState(() {
                _isLoading = false;
              });
            } catch (e) {
              print('Error: $e');
              setState(() {
                _isLoading = false;
                _errorMessage = e.message;
                _formKey.currentState.reset();
              });
            }
          }
        };
      }
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Foster Friends'),
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                child: SizedBox(
                  height: 40.0,
                  child: new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.red,
                    child: new Text('Finish Creating Profile',
                        style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                    onPressed: validateAndSubmit,
                  ),
                ))),
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
              showToggleButton(),
              showFullNameInput(),
              showDescriptionInput(),
              // showLastNameInput(),
              showPhoneInput(),
              showAddressInput(),
              showProfilePicInput(),
              
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

  Widget showFullNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: isIndividual
                ? 'Enter your full name'
                : 'Enter your organization\'s name',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) {
          value = value.trim();
          if (value.isEmpty) {
            _isLoading = false;
            return isIndividual
                ? 'Please enter your first name'
                : 'Please enter your organization\'s name';
          }
          RegExp first = new RegExp(
              "[a-z]+"); // Must be a valid email address, including a prefix, @, and domain with one period.
          if (isIndividual && !first.hasMatch(value.toLowerCase())) {
            _isLoading = false;
            return "Please enter your first name";
          }
          return null;
        },
        onSaved: (value) {
          _name = value;
        },
        controller: name,
      ),
    );
  }

  Widget showAddressInput() {
    if (!isIndividual) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Enter your address',
              icon: new Icon(
                Icons.location_city,
                color: Colors.grey,
              )),
          validator: (value) {
            value = value.trim();
            if (value.isEmpty) {
              _isLoading = false;
              return 'Please enter your address';
            }
            RegExp address = new RegExp("[0-9]+\x20[a-z]+.*");
            if (address.hasMatch(value.toLowerCase())) {
              _isLoading = false;
              return 'Must be a valid address with a number and street';
            }
            return null;
          },
          onSaved: (value) => _address = value,
          controller: address,
        ),
      );
    }
    return SizedBox(height: 0);
  }

  Widget showDescriptionInput() {
    if (!isIndividual) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          // maxLines: 1,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Enter a description of your organization',
              icon: new Icon(
                Icons.description,
                color: Colors.grey,
              )),
          validator: (value) {
            value = value.trim();
            if (value.isEmpty) {
              _isLoading = false;
              return 'Please enter the description';
            }
            return null;
          },
          onSaved: (value) => _description = value,
          controller: description,
        ),
      );
    }
    return SizedBox(height: 0);
  }

  Widget showPhoneInput() {
    // if(!isIndividual) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: isIndividual ? 'Enter your phone number' : 'Enter your organization\'s phone number',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) {
          value = value.trim();
          if (value.isEmpty) {
            _isLoading = false;
            return 'Please enter your phone number';
          }
          RegExp phone = new RegExp("[0-9]{3,}-[0-9]{3,}-[0-9]{4,}");
          if (phone.hasMatch(value)) {
            _isLoading = false;
            return 'Must be a valid phone number with area code and hyphens';
          }
          return null;
        },
        onSaved: (value) => _phone = value,
        controller: phone,
      ),
    );
    // }
    // return SizedBox(height: 0);
  }

  File _image;
  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    photo = image;
    setState(() {
      _image = image;
    });
  }

  
  
  Widget showProfilePicInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xff476cfb),
                child: ClipOval(
                  child: new SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: (_image != null)
                        ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.camera,
                  size: 30.0,
                ),
                onPressed: () {
                  getImage();
                },
              ),
            ),
          ],
        )
      ]));}



  Widget showToggleButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
            onPressed: () {
              setState(() {
                _errorMessage = "";
                isIndividual = true;
              });
            },
            color: isIndividual ? pressed : notPressed,
            child: Text('Individual', style: s)),
        RaisedButton(
            onPressed: () {
              setState(() {
                _errorMessage = "";
                isIndividual = false;
              });
            },
            color: isIndividual ? notPressed : pressed,
            child: Text('Organization', style: s))
      ],
    );
  }
}
