//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:foster_friends/containers/profiles/profile.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/containers/authentication/login_page.dart';

// main application build
class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchState(0);
  }
}

class _ViewModel {
  final FirebaseUser user;
  final Function onLogIn;
  final int selectedIndex;

  _ViewModel({
    this.user,
    this.onLogIn,
    this.selectedIndex
  });

  static _ViewModel fromStore(Store<AppState> store){
    print(store.state.user);
    return new _ViewModel(
      user: store.state.user,

      //selectedIndex: store.state.index,
      //onLogIn: (){
      //  print("Hello!");
      //}
    );
  }

}

// building state
class SearchState extends StatefulWidget {
  // SearchState({Key key}) : super(key: key); // have no idea what this is
  final int index;
  SearchState(this.index);
  @override
  SearchStateUser createState() => SearchStateUser(null, "", index);
}

// This is the bottom bar body options
class SearchStateUser extends State<SearchState> {
  // FirebaseUser _user = store.state.user;
  FirebaseUser _user;
  String _userType;
  int _selectedIndex;

  FirebaseUser get user => _user;
  String get userType => _userType;

  SearchStateUser(this._user, this._userType, this._selectedIndex);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[

    Text("Search"),
    Profile()
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foster Friends'), // top bar
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Contruction of navigation
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
