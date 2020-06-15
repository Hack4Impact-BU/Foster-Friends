import 'package:flutter/material.dart';
import 'package:foster_friends/containers/grid/grid.dart';
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
            return loading();
        }
        else {
          if(store.state.query.first.isNotEmpty)
            return buildGrid(store.state.query, context);
          else
            return new Text("No results found", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),);
        }
      }   
    );
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
