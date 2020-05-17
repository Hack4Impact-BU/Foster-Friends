import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';

class SearchForm extends StatefulWidget {
  @override
  SearchFormState createState() {
    return SearchFormState();
  }
}

class SearchFormState extends State<SearchForm> {
  // -------------------------- save user inputs ----------------------------
  final petAge = TextEditingController();
  final petBreed = TextEditingController();
  final petSex = TextEditingController();
  final petActivityLevel = TextEditingController();
  final petType = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    petBreed.dispose();
    petSex.dispose();
    petActivityLevel.dispose();
    petType.dispose();
    super.dispose();
  }

  // -------------------------- variables for pet type, breed, sex dropdown menu ----------------------------
  //static Map<String, List<String>> map = {'Dog':['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'],'Cat':['Maine Coon','Bengal','Siamese'],'Bird':['Maine Coon','Bengal','Siamese']};
  List<String> _petTypes = ['Dog', 'Cat', 'Bird'];
  List<String> _dogBreed = [
    'Labrador Retrievers',
    'German Shepherd Dogs',
    'Golden Retrievers'
  ];
  List<String> _catBreed = ['Maine Coon', 'Bengal', 'Siamese'];
  List<String> _birdBreed = [''];
  static List<String> _breedType = [];
  String _selectedPetTypes;
  String _selectedBreedTypes;
  String _selectedSex;
  String _selectedActivityLevel;
  List<String> _sex = ['Female', 'Male'];
  List<String> _activity = ['High', 'Medium', 'Low'];

  // -------------------------- enable / disable SUBMIT button ----------------------------
  // bool _enabled = false;

  Color color = const Color(0xFFFFCC80);
  void _onPressed() async {
    /* 
    Type
    Breed
    Sex
    Activity Level
    Age
    Location --> Radius search?
  */
    print("Searching for pet of type $_selectedPetTypes");
    Map<String, String> params = {
      'type': _selectedPetTypes, 
      'breed': _selectedBreedTypes,
      'sex': _selectedSex,
      'activity level': _selectedActivityLevel,
      };
    store.dispatch(makeQuery(store, params));
  }

  @override
  Widget build(BuildContext context) {
    const List<Color> orangeGradients = [
      Color(0xFFFFCC80),
      Color(0xFFFE8853),
      Color(0xFFFEF5350),
    ];
    return Column(children: <Widget>[
      Container(
        alignment: Alignment.topRight,
        child: CloseButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Container(
        width: 200.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 75.0,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Age Min',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a minimum age';
                    }
                    return null;
                  },
                  controller: petAge,
                )),
            Container(width: 20.0),
            Container(
                width: 75.0,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Age Max',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a maximum age';
                    }
                    return null;
                  },
                  controller: petAge,
                ))
          ],
        ),
      ),
      DropdownButton(
        hint: Text('Pet Type'), // Not necessary for Option 1
        value: _selectedPetTypes,
        onChanged: (newValue) {
          _selectedBreedTypes = null;
          setState(() {
            petType.text = newValue;
            _selectedPetTypes = newValue;
            if (newValue == "Dog") {
              _breedType = _dogBreed;
            } else if (newValue == "Cat") {
              _breedType = _catBreed;
            } else if (newValue == "Bird") {
              _breedType = _birdBreed;
            }
          });
        },
        items: _petTypes.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      DropdownButton(
        hint: Text('Breed'), // Not necessary for Option 1
        value: _selectedBreedTypes,
        onChanged: (newValue) {
          setState(() {
            petBreed.text = newValue;
            _selectedBreedTypes = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _breedType.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      DropdownButton(
        hint: Text('Sex'), // Not necessary for Option 1
        value: _selectedSex,
        onChanged: (newValue) {
          setState(() {
            petSex.text = newValue;
            _selectedSex = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _sex.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      DropdownButton(
        hint: Text('Activity Level'), // Not necessary for Option 1
        value: _selectedActivityLevel,
        onChanged: (newValue) {
          setState(() {
            petActivityLevel.text = newValue;
            _selectedActivityLevel = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _activity.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
          child: Center(
              child: RaisedButton(
            color: Theme.of(context).buttonColor,
            onPressed: _onPressed,
            child: Text("Find a friend!",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).backgroundColor)),
          ))),
    ]);
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    //creating first curver near bottom left corner
    var firstControlPoint = new Offset(size.width / 7, size.height - 80);
    var firstEndPoint = new Offset(size.width / 2, size.height / 2);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    //creating second curver near center
    var secondControlPoint = Offset(size.width / 2, size.height / 5);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    //creating third curver near top right corner
    var thirdControlPoint =
        Offset(size.width - (size.width / 11), size.height / 5);
    var thirdEndPoint = Offset(size.width, 0.0);

    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move to top right corner
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
