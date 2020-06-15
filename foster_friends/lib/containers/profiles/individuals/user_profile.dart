import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/containers/grid/grid.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';
import 'package:foster_friends/containers/profiles/individuals/edit_individual_profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String name;
//String description;
String email;
String phoneNumber;
String photo;
List pets = [];
//List<Map<String, dynamic>> petInfo = [];
//Map<String, dynamic> orgInfo;


// Define a custom Form widget.
class UserProfile extends StatefulWidget {
  final data;
  UserProfile(this.data);

  @override
  UserState createState() {
    return UserState(this.data);
  }
}

class UserState extends State<UserProfile> {
  Map<String, dynamic> data;
  UserState(this.data);

  @override
  void initState() {
    final data = store.state.userData;
    //print("User data is $data");
    name = data['name'];
    email = data['email'];
    phoneNumber = data['phone number'];
    photo = data['photo'];
    pets = data['pets'];

   // print("Data is\n$name\n$description\n$phoneNumber\n$photo\n$pets");

    super.initState();
  }

  bool _anyAreNull() {
    final data = store.state.userData;

    return data['name'] == null ||
        data['email'] == null ||
        data['phone number'] == null ||
        data['photo'] == null ||
        data['pets'] == null;
  }

  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ProfileViewModel>(
        converter: _ProfileViewModel.fromStore,
        builder: (BuildContext context, _ProfileViewModel vm) {
          if (_anyAreNull()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(photo),
                          ),
                          SizedBox(height: 10,),
                          Text(name,
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(height: 10,),
                          Text(email,
                              style: TextStyle(fontFamily: 'roboto',
                                  fontSize: 16,letterSpacing: 1.5)),
                          SizedBox(height: 5,),
                          Text(phoneNumber,
                              style: TextStyle(fontFamily: 'roboto',
                                  fontSize: 16,letterSpacing: 1.5)),
                          Row (
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: RaisedButton(
                              color: Theme.of(context).buttonColor,
                              child: Text("Edit Profile",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).backgroundColor)),
                              onPressed: () {
                                //Navigator.pop(context);
                                showDialog(context: context, builder: (BuildContext context) => EditIndividualProfile(data));
                              })),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: IconButton(
                                  icon: Icon(FontAwesomeIcons.signOutAlt),
                                  color: Theme.of(context).buttonColor,
                                  onPressed: () {
                                    signOut();
                                  },
                                  // child: Text("Sign Out",
                                  //     style: TextStyle(
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.bold,
                                  //         color:
                                  //             Theme.of(context).backgroundColor)),
                                )),
                            ]),
                          Divider(color: Colors.grey),
                          Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).copyWith().size.width,
                              height: MediaQuery.of(context).copyWith().size.height - 500,
                              child: buildGrid(pets, context)),
                        ]))));
          }
        });
  }
}

class _ProfileViewModel {
  final List pets;

  _ProfileViewModel({this.pets});

  static _ProfileViewModel fromStore(Store<AppState> store) {
    return new _ProfileViewModel(pets: store.state.userData['pets']);
  }
}
