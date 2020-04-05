import 'package:flutter/material.dart';

enum Choices { lafayette, jefferson }

// ...

Choices _choice = Choices.lafayette;

Widget build(BuildContext context) {
  return Column(
    children: <Widget>[
      ListTile(
        title: const Text('Lafayette'),
        leading: Radio(
          value: Choices.lafayette,
          groupValue: _choice,
          onChanged: (Choices value) {
            setState(() { _choice = value; });
          },
        ),
      ),
      ListTile(
        title: const Text('Thomas Jefferson'),
        leading: Radio(
          value: Choices.jefferson,
          groupValue: _choice,
          onChanged: (Choices value) {
            setState(() { _choice = value; });
          },
        ),
      ),
    ],
  );
}

void setState(Null Function() param0) {
}