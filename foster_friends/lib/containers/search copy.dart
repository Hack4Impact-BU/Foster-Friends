//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/login_page.dart';
import 'package:foster_friends/badProfile.dart';

FirebaseUser user;
// main application build
class Search extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
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
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Search Page',
      style: optionStyle,
    ),
    LoginPage(),
    BadProfile()
    // BadProfile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      // print('index'+index.toString());
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foster Friends'), // top bar
      ),
      body: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Search"),
          TextField(
            decoration: InputDecoration(hintText: "Search query here..."),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                color: Colors.blue,
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ],
          ),
          _widgetOptions.elementAt(_chooseBody(_selectedIndex)),
        ],
      ),
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

  int _chooseBody(int i) {
    _getUser();
    print('Clicked on ' + i.toString());
    if (i == 1) {
      if (user == null) {
        print('Not signed in ' + 1.toString());
        return 1;
      }
      print('Choosing body');
      return 2;
    }
    print('user is ' + user.toString());
    return i;
  }

  void _getUser() async {
    user  = await FirebaseAuth.instance.currentUser();
    print('user is '+ user.toString());
  }
}

// Future<List<Post>> search(String search) async {
// await Future.delayed(Duration(seconds: 2));
// return List.generate(search.length, (int index) {
//   print("Searching");
//   return Post(
//     "Title : $search $index",
//     "Description :$search $index",
//   );
// });
// }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: SearchBar<Post>(
//             onSearch: search),
//         ),
//       ),
//     );
//   }
// }

// class Post {
//   final String title;
//   final String description;

//   Post(this.title, this.description);
// }
