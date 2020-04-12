

import 'package:flutter/material.dart';
import 'package:foster_friends/radioButton.dart';


class SignUpForm extends StatefulWidget{
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>{

  @override
  Widget build(BuildContext context){
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Foster Friends')),
    //   body: RadioButton()
    // );
    return Scaffold(
      appBar: AppBar(title: const Text('Foster Friends')),
      body: RadioButton()
    );
  }
}

Widget signUpUI(){
  return Padding(padding: EdgeInsets.all(10),
    child: Column(
      children: <Widget>[
        RadioButton()

      ]
    ),
  );
}