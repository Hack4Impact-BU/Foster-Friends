// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import './login.dart';
import './landing.dart';

void main() => runApp(MaterialApp(
  title: 'Navigation',
  theme: ThemeData.dark(),
  initialRoute: '/',
  routes: {
    '/': (context) => MyApp(),
    '/LogIn': (BuildContext context) => new LogIn()
  }
));

