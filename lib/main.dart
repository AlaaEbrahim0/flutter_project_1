// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:world_time_app/pages/login.dart';
import 'package:world_time_app/pages/profile.dart';
import 'package:world_time_app/pages/register.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => Login(),
      '/register': (context) => Register(),
      '/profile': (context) => Profile(),
    },
  ));
}
