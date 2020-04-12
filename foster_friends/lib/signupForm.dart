

import 'package:flutter/material.dart';


class SignUpForm extends StatefulWidget{
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SignUpUI()
    );
  }
}

Widget SignUpUI(){
  return Padding(padding: EdgeInsets.all(10),
    child: Row(
      children: <Widget>[
        
      ]
    ),
  );
}