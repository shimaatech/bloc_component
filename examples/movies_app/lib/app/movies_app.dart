import 'package:flutter/material.dart';

import 'app_home.dart';

class MoviesApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppHome(),
    );
  }
}