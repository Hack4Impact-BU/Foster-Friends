import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redux/redux.dart';

String name;
String email;
String phoneNumber;
String photo;

// Define a custom Form widget.
class EditIndividualProfile extends StatefulWidget {

  final data;
  final refresh;
  EditIndividualProfile(this.data,this.refresh);

  @override
  EditIndividualState createState() => EditIndividualState(data,this.refresh);
}



class EditIndividualState extends State<EditIndividualProfile> {
  Map<String, dynamic> data;
  final Function refresh;
  EditIndividualState(this.data,this.refresh);

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController phoneNumCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = store.state.userData;
    name = data['name'];
    email = data['email'];
    phoneNumber = data['phone number'];
    photo = data['photo'];

    nameCon = TextEditingController(text: name);
    emailCon = TextEditingController(text: email);
    phoneNumCon = TextEditingController(text: phoneNumber);
  }

  @override
  void dispose() {
    // store.dispatch(getFirebaseUser);
    super.dispose();
    nameCon.dispose();
    emailCon.dispose();
    phoneNumCon.dispose(); 
  }

  bool _anyAreNull() {
    final data = store.state.userData;

    return data['name'] == null ||
        data['email'] == null ||
        data['phone number'] == null ||
        data['photo'] == null;
  }

// -------------------------- upload photo -------------------------------
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      // print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    photo = fileName;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    await uploadTask.onComplete;
    setState(() {
      // print("Profile Picture uploaded");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  void _saveEdit(BuildContext context) async {
    DocumentReference ref =
      Firestore.instance.collection("users").document(store.state.user.uid);
    await ref.updateData({
      "name": nameCon.text,
      "email": emailCon.text,
      "phone number": phoneNumCon.text,
      "photo": photo,
    });

    store.dispatch(new UpdateUserAction(null,{}));
    store.dispatch(getFirebaseUser);
    widget.refresh();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text("Done",
              style: TextStyle(fontSize: 20.0, color: Colors.red[500]),
            ),
            onPressed: () {
              _saveEdit(context);
          }),
        ]
      ),
      body: ListView(
        children: <Widget>[
          Container(child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              // CircleAvatar(
              //   radius:70,
              //   backgroundImage: NetworkImage(photo),
              
              CircleAvatar(
                radius:70,
                backgroundColor: Color(0xff476cfb),
                  child: ClipOval(
                    child: new SizedBox(
                      width: 140.0,
                      height: 140.0,
                      child: (_image != null)
                          ? Image.file(
                              _image,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              photo,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
              ),
              Center(
                child: FlatButton(
                  onPressed: (){
                    // print("Pressed change profile photo");
                    getImage();
                  },
                  child: Text("Change Profile Photo",
                    style: TextStyle(fontSize: 18, color: Colors.red[500]),
                    ),
              ),),
              SizedBox(height: 10,),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: nameCon,
                          style: TextStyle(fontSize:18),
                          decoration:
                            InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(fontSize:20),
                              icon: Icon(Icons.person),
                              ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: emailCon,
                          style: TextStyle(fontSize:18),
                          keyboardType: TextInputType.emailAddress,
                          decoration: 
                            InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(fontSize:20),
                              icon: Icon(Icons.email)
                              ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                            else if (!value.contains("@")){
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: phoneNumCon,
                          // initialValue: phoneNumber,
                          style: TextStyle(fontSize:18),
                          keyboardType: TextInputType.number,
                          decoration: 
                            InputDecoration(
                              labelText: "Phone Number",
                              labelStyle: TextStyle(fontSize:20),
                              icon: Icon(Icons.phone)
                              ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ],),
                    )
              ),
            ]
          ))
        ],)
      
      ));
  } 
}



class _QueryViewModel {
  final List<Map<String,dynamic>> pets;

  _QueryViewModel({
    this.pets
  });

  static _QueryViewModel fromStore(Store<AppState> store){
    return new _QueryViewModel(
      pets: store.state.query 
    );
  }

}

Widget loading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}