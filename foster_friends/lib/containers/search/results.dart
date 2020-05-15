import 'package:flutter/material.dart';
import 'package:foster_friends/containers/profiles/organizations/pet_profile.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class Results extends StatefulWidget {
  @override
  _Results createState() => _Results();
}

class _Results extends State<Results> {
  List<Map<String, dynamic>> pets;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _QueryViewModel>(
      converter: _QueryViewModel.fromStore,
      builder: (BuildContext context, _QueryViewModel vm){
        if(store.state.query.isEmpty){
          return _loading();
        } else{
          return _buildGrid(context);
        }
      }   
    );
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildGrid(BuildContext context) {
    if (store.state.query.isEmpty) {
      return _loading();
    } else {
      return GridView.count(
          // shrinkWrap: true,
          crossAxisCount: 3,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(4),
          children: _buildGridTileList(store.state.query.length, context));
    }
  }

  List<Widget> _buildGridTileList(int count, BuildContext context) =>
      List.generate(count, (i) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        _chooseImage(store.state.query[i]['image'])),
                    fit: BoxFit.cover),
              ),
              child: FlatButton(
                child: null,
                // padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // showDialog(context: context, builder:(BuildContext context) => PetProfile() );
                  Navigator.pushNamed(context, '/Pet_Profile',
                      arguments: store.state.query[i]);
                },
              )),
        );
      });

  String _chooseImage(String pet) {
    // print("url is $pet");

    if (pet == null) {
      return 'http://www.hostingreviewbox.com/wp-content/uploads/2016/02/image-error.png';
    } else if (pet.substring(0, 8) != 'https://' && pet.substring(0, 7) != 'http://'  ) {
      var a = pet.substring(0, 8);
      // print(a + " " + a.length.toString());
      return 'http://www.hostingreviewbox.com/wp-content/uploads/2016/02/image-error.png';
    }

    return pet;
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
