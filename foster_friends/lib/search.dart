//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/no_signin.dart';
import 'package:foster_friends/user_profile.dart';
import 'package:foster_friends/org_profile.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:foster_friends/appState.dart';
import 'package:foster_friends/userState.dart';

// main application build
class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Foster Friends",
      home: SearchState(),
    );
  }
}

// building state
class SearchState extends StatefulWidget {
  SearchState({Key key}) : super(key: key); // have no idea what this is
  @override
  _SearchState createState() => _SearchState();
}

// This is the bottom bar body options
class _SearchState extends State<SearchState> {
  String _user;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    // StoreConnector<AppState, AppState>(
    //   converter: (store) => store.state,
    //   builder: (_, state) {
    //     return new Text(
    //       '${state.user}',
    //       textAlign: TextAlign.center,
    //       style: const TextStyle(fontSize: 20.0),
    //     );
    //   },
    // ),
    new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return new Text(
              '${state.user}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20.0),
            );
          },
        ),
        // StoreConnector<AppState, GenerateUser>(
        //   converter: (store) => () => store.dispatch(getFirebaseUser),
        //   builder: (_, generateUserCallback) {
        //     return new FlatButton(
        //         color: Colors.lightBlue,
        //         onPressed: generateUserCallback,
        //         child: new Text("Get user"));
        //   },
        // ),
      ],
    ),
    NoSignIn(),
    UserProfile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = _chooseWidget(index);
    });
  }

  int _chooseWidget(index) {
    if (_user != null) {
      return index + 1;
    }
    return index;
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
