// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foster Friends',
      home: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Text('Foster Friends', 
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.red,
                  decoration: TextDecoration.none
                ))
            ),
          ],
        ),
        color: Colors.white,
      )
    );
  }
}
