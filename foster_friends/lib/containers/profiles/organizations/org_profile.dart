import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/containers/grid/grid.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';
import './uploadPet.dart';
import 'package:foster_friends/containers/profiles/organizations/edit_org_profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


String name;
String description;
String email;
String phoneNumber;
String photo;
String address;
List pets = [];
List<Map<String, dynamic>> petInfo = [];
Map<String, dynamic> orgInfo;


// Define a custom Form widget.
class OrgProfile extends StatefulWidget {
  final data;

  OrgProfile(this.data);

  @override
  OrgState createState() {
    return OrgState(this.data);
  }
}

class OrgState extends State<OrgProfile> {
  Map<String, dynamic> data;
  OrgState(this.data);

  @override
  void initState() {
    final data = store.state.userData;
    //print("User data is $data");
    name = data['name'];
    description = data['description'];
    phoneNumber = data['phone number'];
    photo = data['photo'];
    pets = data['pets'];
    email = data['email'];
    address = data['address'];

   // print("Data is\n$name\n$description\n$phoneNumber\n$photo\n$pets");

    super.initState();
  }

  bool _anyAreNull() {
    final data = store.state.userData;

    return data['name'] == null ||
        data['description'] == null ||
        data['phone number'] == null ||
        data['photo'] == null ||
        data['pets'] == null ||
        data['email'] == null ||
        data['address'] == null;
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
              
                body: Center(
                    //margin: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(photo),
                          ),
                        ),
                          Text(name,
                              style: Theme.of(context).textTheme.headline6),
                          Text("Phone number: " + phoneNumber,
                               style: TextStyle(color: Colors.red,fontFamily: 'roboto',
                                  fontSize: 15.0,letterSpacing: 1.5)),
                          Text("Email: " + email,
                             style: TextStyle(color: Colors.red,fontFamily: 'roboto',
                                  fontSize: 15.0,letterSpacing: 1.5)),
                          Text("Address: " + address,
                             style: TextStyle(color: Colors.red,fontFamily: 'roboto',
                                  fontSize: 15.0,letterSpacing: 1.5)),
                          Text("Description: " + description,
                              style: TextStyle(color: Colors.red,fontFamily: 'roboto',
                                  fontSize: 15.0,letterSpacing: 1.5)),
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
                              Navigator.pop(context);
                              showDialog(context: context, builder: (BuildContext context) => EditOrgProfile(data));
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
                          ],),
                          
                          Divider(color: Colors.grey),
                          
                          Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).copyWith().size.width,
                              height: MediaQuery.of(context).copyWith().size.height - 550,
                              child: buildGrid(pets, context)),
                          ])),
                          
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => new UploadPet()));
                            },
                            child: Icon(Icons.file_upload),
                            backgroundColor: Color(0xFFFEF53500),
                          ),
                        );
          }
        });
  }
}

class _ProfileViewModel {
  final List<Map<String, dynamic>> pets;

  _ProfileViewModel({this.pets});

  static _ProfileViewModel fromStore(Store<AppState> store) {
    return new _ProfileViewModel(pets: store.state.userData['pets']);
  }
}
