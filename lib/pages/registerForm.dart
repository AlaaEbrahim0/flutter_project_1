// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_time_app/pages/database/database_service.dart';
import 'package:world_time_app/pages/enums/gender.dart';
import 'package:world_time_app/pages/models/student.dart';

const List<int> allowedLevelValues = [1, 2, 3, 4];

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  Gender gender = Gender.male;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  int selectedLevel = 1;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final levelController = TextEditingController();
  final studentDb = StudentDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              // border: OutlineInputBorder(),

              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Name',
              hintText: 'Enter your name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                name = value!.trim();
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
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
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
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
          SizedBox(height: 20),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: !confirmPasswordVisible,
            decoration: InputDecoration(
              // border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10)),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Confirm Password',
              hintText: '',
              suffixIcon: IconButton(
                icon: Icon(confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(
                    () {
                      confirmPasswordVisible = !confirmPasswordVisible;
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
                return 'Please confirm your password';
              } else if (value != password) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: levelController,
            decoration: InputDecoration(
              // border: OutlineInputBorder(),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Level',
              hintText: 'Enter your level [1-4]',
            ),
            validator: (value) {
              if (!allowedLevelValues.contains(int.parse(value!))) {
                return 'Level must be between 1 and 4';
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Male'),
                  leading: Radio<Gender>(
                    value: Gender.male,
                    activeColor: Colors.blueGrey,
                    groupValue: gender,
                    onChanged: (Gender? value) {
                      setState(() {
                        gender = value!;
                        print(gender);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('Female'),
                  leading: Radio<Gender>(
                    value: Gender.female,
                    groupValue: gender,
                    onChanged: (Gender? value) {
                      setState(() {
                        gender = value!;
                        print(gender);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
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
                print(nameController.value.text);
                print(emailController.value.text);
                print(passwordController.value.text);
                print(confirmPasswordController.value.text);
                print(levelController.value.text);
                print(gender.name);
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  try {
                    debugger;
                    int id = await studentDb.create(
                      name: nameController.value.text,
                      email: emailController.value.text,
                      level: int.parse(levelController.value.text),
                      password: passwordController.value.text,
                      gender: gender.name,
                      image: null,
                    );
                    print('output id: $id');
                    Student student = await studentDb.fetchById(1);
                    print(student.email);
                  } catch (e) {
                    print(e);
                  }

                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Your account has been created successfully'),
                      backgroundColor: Color.fromARGB(255, 45, 207, 129),
                      duration: Duration(seconds: 3),
                      showCloseIcon: true,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to Register'),
                      backgroundColor: Color.fromARGB(255, 207, 45, 45),
                      duration: Duration(seconds: 3),
                      showCloseIcon: true,
                    ),
                  );
                }
              },
              child: Text(
                'Register',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
