import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/containers/grid/grid.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';

String name;
String description;
String email;
String phoneNumber;
String photo;
List pets;

// Define a custom Form widget.
class OrgProfile extends StatefulWidget {
  @override
  OrgState createState() {
    return OrgState();
  }
}

class OrgState extends State<OrgProfile> {
  @override
  void initState() {
    final data = store.state.userData;
    print("User data is $data");
    name = data['name'];
    description = data['description'];
    phoneNumber = data['phone number'];
    photo = data['photo'];
    pets = data['pets'];

    print("Data is\n$name\n$description\n$phoneNumber\n$photo\n$pets");

    super.initState();
  }

  bool _anyAreNull() {
    final data = store.state.userData;

    return data['name'] == null ||
        data['description'] == null ||
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
            return SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(photo),
                          ),
                          Text(name,
                              style: Theme.of(context).textTheme.headline6),
                          Text(description,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'roboto',
                                  fontSize: 15.0,
                                  letterSpacing: 1.5),
                              textAlign: TextAlign.center),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: RaisedButton(
                                color: Theme.of(context).buttonColor,
                                onPressed: () {
                                  signOut();
                                },
                                child: Text("Sign Out",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).backgroundColor)),
                              )),
                          Divider(color: Colors.grey),
                          Container(
                              margin: const EdgeInsets.all(10.0),
                              width: 400.0,
                              height: 400.0,
                              child: buildGrid(pets, context)),
                        ])));
          }
        });
  }
}

class _ProfileViewModel {
  final List<Map<String, dynamic>> pets;

  _ProfileViewModel({this.pets});

  static _ProfileViewModel fromStore(Store<AppState> store) {
    return new _ProfileViewModel(pets: store.state.query);
  }
}
