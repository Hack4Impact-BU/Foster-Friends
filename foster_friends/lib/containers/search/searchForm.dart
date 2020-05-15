import 'package:flutter/material.dart';

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
  List<String> _dogBreed = ['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'];
  List<String> _catBreed = ['Maine Coon','Bengal','Siamese'];
  List<String> _birdBreed = [''];
  static List<String> _breedType = [];
  String _selectedPetTypes;
  String _selectedBreedTypes;
  String _selectedSex;
  String _selectedActivityLevel;
  List<String> _sex = ['Female','Male'];
  List<String> _activity = ['High','Medium','Low'];

  // -------------------------- enable / disable SUBMIT button ----------------------------
  // bool _enabled = false;

  Color color = const Color(0xFFFFCC80);

  @override
  Widget build(BuildContext context) {
    var _onPressed;
    if (petAge!="" && petType!="" && petBreed!="" && petSex!="" && petActivityLevel!="") {
      _onPressed = () async {
        print("Searching for pet");
      };
    }
    const List<Color> orangeGradients = [
      Color(0xFFFFCC80),
      Color(0xFFFE8853),
      Color(0xFFFEF5350),
    ];
    return Column(children: <Widget>[
      ClipPath(
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
      
      Container(width: 100.0, child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Pet Age',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet age';
            }
            return null;
          },
          controller: petAge,
      )),
      DropdownButton(
            hint: Text('Select a Pet Type'), // Not necessary for Option 1
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
        hint: Text('Select a Breed Type'), // Not necessary for Option 1
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
        hint: Text('Select a Sex'), // Not necessary for Option 1
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
        hint: Text('Select an Activity Level'), // Not necessary for Option 1
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

      SizedBox(height: 10,),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 30, 0),
            child: Center(
              child: RaisedButton(
                color: Theme.of(context).buttonColor,
                onPressed: _onPressed,
                child: Text("SUBMIT",
                style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor)),
              ))),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
                
                child: Text("CANCEL",
                  style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          )),
                
              )))]),
              
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
    var thirdControlPoint = Offset(size.width - (size.width / 11), size.height / 5);
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