// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:world_time_app/pages/login.dart';
import 'package:world_time_app/pages/loginForm.dart';
import 'package:world_time_app/pages/models/student.dart';
import 'package:world_time_app/pages/profileUpdateFrom.dart';
import 'package:world_time_app/pages/registerForm.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Student student = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: Column(
              children: [
                ProfileForm(
                  student: student,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
