import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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
          final a = store.state.userData;
          print(a);
          if (_anyAreNull()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
                child: Scaffold(
                    body: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    NetworkImage(_chooseImage(photo)),
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
                              Divider(color: Colors.grey),
                              Container(
                                  margin: const EdgeInsets.all(10.0),
                                  width: 400.0,
                                  height: 400.0,
                                  child: _buildGrid(context)),
                            ]))));
            ;
          }
        });
  }
}

String _chooseImage(String pet) {
  // print("url is $pet");

  if (pet == null) {
    return 'http://www.hostingreviewbox.com/wp-content/uploads/2016/02/image-error.png';
  } else if (pet.length < 7) {
    return 'http://www.hostingreviewbox.com/wp-content/uploads/2016/02/image-error.png';
  } else if (pet.substring(0, 8) != 'https://'){
      if (pet.substring(0, 7) != 'http://') {
            return 'http://www.hostingreviewbox.com/wp-content/uploads/2016/02/image-error.png';

      }
  }

  return pet;
}

Widget _buildGrid(BuildContext context) => GridView.count(
    shrinkWrap: true,
    crossAxisCount: 3,
    scrollDirection: Axis.vertical,
    padding: const EdgeInsets.all(4),
    children: _buildGridTileList(pets.length, context));

List<Widget> _buildGridTileList(int count, BuildContext context) {
  print("Count is $count");
  if(count < 1){
    return new List(0);
  }
  return  List.generate(count, (i) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(_chooseImage(pets[i]['Photo'])),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: FlatButton(
                child: null,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/Pet_Profile',
                      arguments: pets[i]);
                },
              )),
        ),
      );
    });
}

class _ProfileViewModel {
  final List<Map<String, dynamic>> pets;

  _ProfileViewModel({this.pets});

  static _ProfileViewModel fromStore(Store<AppState> store) {
    return new _ProfileViewModel(pets: store.state.query);
  }
}
