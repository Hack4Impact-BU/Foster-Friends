

import 'package:flutter/material.dart';
// import 'package:foster_friends/radioButton.dart';

class SignUpForm extends StatefulWidget{
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>{
  TextStyle s = TextStyle(color: Colors.white);

  Color pressed = Colors.red;
  Color notPressed = Colors.grey;
  bool isIndividual = true;

  @override
  Widget build(BuildContext context){
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Foster Friends')),
    //   body: RadioButton()
    // );
    return Scaffold(
      appBar: AppBar(title: const Text('Foster Friends')),
      body: Column(children: <Widget>[
        radioButton(),
        Text(isIndividual.toString()),
        showBasic(),
        showOrg()
      ],)
    );
  }

  Widget radioButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(onPressed: (){
          setState((){
            isIndividual = true;
          });
        },
          color: isIndividual ? pressed : notPressed,
          child: Text('Individual', style: s)
        ),
        RaisedButton(onPressed: (){
          setState(() {
            isIndividual = false;
          });
        },
        color: isIndividual ? notPressed : pressed,
        child: Text('Organization', style: s))
      ],
    );
  }

    Widget showBasic(){
    return Column(
      children: <Widget>[
        Text('Name'),
        Text('Phone')
      ],
    );
  }

  Widget showOrg(){
    if(!isIndividual){
      return Column(children: <Widget>[
        Text('Address')
      ],);
    }
    return new Container(
        height: 0.0,
      );
  }
}
