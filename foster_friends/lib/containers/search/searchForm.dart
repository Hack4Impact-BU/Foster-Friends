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
  final petAge1 = TextEditingController();
  final petBreed = TextEditingController();
  final petSex = TextEditingController();
  final petActivityLevel = TextEditingController();
  final petType = TextEditingController();
  final radius = TextEditingController();

  final _formKey = new GlobalKey<FormState>();

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
  List<String> _petTypes = ['', 'Dog', 'Cat', 'Bird'];
  List<String> _dogBreed = [
    '',
    'Labrador Retrievers',
    'German Shepherd Dogs',
    'Golden Retrievers'
  ];
  List<String> _catBreed = ['', 'Maine Coon', 'Bengal', 'Siamese'];
  List<String> _birdBreed = [''];
  List<String> _sex = ['', 'Female', 'Male'];
  List<String> _activity = ['', 'High', 'Medium', 'Low'];
  List<dynamic> _ages = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19
  ];

  List<String> _radiusOptions = [''] + List.generate(10, (index) => ((index+1)*5).toString());

  static List<String> _breedType = [];

  String _selectedPetTypes;
  String _selectedBreedTypes;
  String _selectedSex;
  String _selectedActivityLevel;
  int minAge;
  int maxAge;
  String _radius;

  // -------------------------- enable / disable SUBMIT button ----------------------------
  // bool _enabled = false;

  Color color = const Color(0xFFFFCC80);
  void _onPressed() async {
    final form = _formKey.currentState;
    form.save();
    /* 
    Type
    Breed
    Sex
    Activity Level
    Age
    Location --> Radius search?
  */
    Map<String, dynamic> params = {
      'type': _selectedPetTypes,
      'breed': _selectedBreedTypes,
      'sex': _selectedSex,
      'activityLevel': _selectedActivityLevel,
      'minAge': minAge,
      'maxAge': maxAge,
      'distance': (_radius == '' || _radius==null) ? null : double.parse(_radius)
    };
    store.dispatch(makeQuery(store, params));
    store.state.searching = true;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: new ListView(shrinkWrap: true, children: <Widget>[
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
                  width: 90.0,
                  child: DropdownButton(
                    hint: Text('Age Min'), // Not necessary for Option 1
                    value: minAge,
                    onChanged: (newValue) {
                      setState(() {
                        minAge = newValue;
                      });
                    },
                    items: _ages
                        .sublist(0, maxAge != null ? maxAge : _ages.last)
                        .map((location) {
                      //if(maxAge == null || location < maxAge) {
                      return DropdownMenuItem(
                        child: Text(location.toString()),
                        value: location,
                      );
                    }
                            //}
                            ).toList(),
                  ),
                ),
                Container(width: 20.0),
                Container(
                  width: 90.0,
                  child: DropdownButton(
                    hint: Text('Age Max'), // Not necessary for Option 1
                    value: maxAge,
                    onChanged: (newValue) {
                      maxAge = null;
                      setState(() {
                        maxAge = newValue;
                      });
                    },
                    items: _ages
                        .sublist(
                            minAge != null ? minAge : _ages.first, _ages.last)
                        .map((location) {
                      return DropdownMenuItem(
                        child: Text(location.toString()),
                        value: location,
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          Container(
              width: 300,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton(
                      hint: Text('Pet Type'), // Not necessary for Option 1
                      value: _selectedPetTypes,
                      onChanged: (newValue) {
                        print("old value: $_selectedPetTypes");
                        _selectedBreedTypes = null;
                        _selectedPetTypes = newValue;
                        print("new value is $_selectedPetTypes");
                        setState(() {
                          if (_selectedPetTypes == "Dog") {
                            _breedType = _dogBreed;
                          } else if (_selectedPetTypes == "Cat") {
                            _breedType = _catBreed;
                          } else if (_selectedPetTypes == "Bird") {
                            _breedType = _birdBreed;
                          } else {
                            _selectedPetTypes = null;
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
                          if (newValue == '') {
                            _selectedBreedTypes = null;
                          } else {
                            _selectedBreedTypes = newValue;
                          }
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
                          if (newValue == '') {
                            _selectedSex = null;
                          } else {
                            _selectedSex = newValue;
                          }
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
                      hint:
                          Text('Activity Level'), // Not necessary for Option 1
                      value: _selectedActivityLevel,
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue == '') {
                            _selectedActivityLevel = null;
                          } else {
                            _selectedActivityLevel = newValue;
                          }
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
                    DropdownButton(
                      hint:
                          Text('Within'), // Not necessary for Option 1
                      value: _radius,
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue == '') {
                            _radius = null;
                          } else {
                            _radius = newValue;
                          }
                        });
                      },
                      // ??????????????????????? if () _breedType
                      items: _radiusOptions.map((location) {
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
                        )))
                  ])),
        ]));
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
