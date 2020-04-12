import 'package:flutter/material.dart';

enum UserType { individual, organization }

class RadioButton extends StatefulWidget {
  // MyStatefulWidget({Key key}) : super(key: key);

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  UserType type = UserType.individual;

  TextStyle s = TextStyle(color: Colors.white);

  Color pressed = Colors.red;
  Color notPressed = Colors.grey;
  bool isIndividual = true;

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(onPressed: (){
          setState((){
            isIndividual = true;
            type = UserType.individual;
          });
        },
          color: isIndividual ? pressed : notPressed,
          child: Text('Individual', style: s)
        ),
        RaisedButton(onPressed: (){
          setState(() {
            isIndividual = false;
            type = UserType.organization;
          });
        },
        color: isIndividual ? notPressed : pressed,
        child: Text('Organization', style: s))
      ],
    );
  }


  
}
