// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_time_app/pages/database/database_service.dart';
import 'package:world_time_app/pages/models/student.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  String email = '';
  String password = '';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final studentDb = StudentDb();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Email',
              hintText: 'studentID@stud.fci-cu.edu.eg',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an email';
              } else if (!RegExp(r'^[0-9]+@stud\.fci-cu\.edu\.eg$')
                  .hasMatch(value)) {
                return 'Email must match the format: studentID@stud.fci-cu.edu.eg';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordController,
            obscureText: !passwordVisible,
            decoration: InputDecoration(
              // border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10)),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Password',
              hintText: '',
              suffixIcon: IconButton(
                icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(
                    () {
                      passwordVisible = !passwordVisible;
                    },
                  );
                },
              ),
              alignLabelWithHint: false,
            ),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a password';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 113, 57, 253),
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  print(emailController.value.text);
                  print(passwordController.value.text);

                  debugger();
          
                  Student student =
                      await studentDb.fetchByEmail(emailController.value.text);

                  if (student.password == passwordController.value.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfully Logged In'),
                        backgroundColor: Color.fromARGB(255, 45, 207, 129),
                        duration: Duration(seconds: 3),
                        showCloseIcon: true,
                      ),
                    );
                    Navigator.pushReplacementNamed(
                      context,
                      '/profile',
                      arguments: student
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email or Password is incorrect'),
                        backgroundColor: Color.fromARGB(255, 207, 45, 45),
                        duration: Duration(seconds: 3),
                        showCloseIcon: true,
                      ),
                    );
                  }
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to Log In'),
                      backgroundColor: Color.fromARGB(255, 207, 45, 45),
                      duration: Duration(seconds: 3),
                      showCloseIcon: true,
                    ),
                  );
                }
              },
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
