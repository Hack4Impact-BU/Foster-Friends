//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:foster_friends/containers/profiles/profile.dart';
import 'package:foster_friends/containers/search/search.dart';
import 'package:foster_friends/containers/search/results.dart';
import 'package:foster_friends/main.dart';


// main application build
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeState(0);
  }
}

// building state
class HomeState extends StatefulWidget {
  // SearchState({Key key}) : super(key: key); // have no idea what this is
  final int index;
  HomeState(this.index);
  @override
  _HomeState createState() => _HomeState(null, "", index);
}

// This is the bottom bar body options
class _HomeState extends State<HomeState> {
  @override
  void initState() {
    store.dispatch(getFirebaseUser);
    store.dispatch(getFirebaseUserPet);
    store.dispatch(makeQuery(store, {}));

    super.initState();
  }

  FirebaseUser _user;
  String _userType;
  int _selectedIndex;

  FirebaseUser get user => _user;
  String get userType => _userType;

  _HomeState(this._user, this._userType, this._selectedIndex);


  static List<Widget> _widgetOptions = <Widget>[Results(), Profile()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<Color> orangeGradients = [
      Color(0xFFFFCC80),
      Color(0xFFFE8853),
      Color(0xFFFEF5350),
    ];
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            title: const Text('Foster Friends'), // top bar
            //backgroundColor: Color(0xFFFFCC80),
            flexibleSpace: ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: orangeGradients,
                      begin: Alignment.topLeft,
                      end: Alignment.center),
                ),
                height: MediaQuery.of(context).size.height / 7.5,
              ),
            ),
          )),
      floatingActionButton: (_selectedIndex == 1)
          ? null
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Search());
              },
              child: Icon(Icons.search),
              backgroundColor: Color(0xFFFEF53500),
            ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Contruction of navigation
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Color(0xFFFFCC80),
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
