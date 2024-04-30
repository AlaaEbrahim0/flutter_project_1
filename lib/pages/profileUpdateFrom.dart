// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:world_time_app/pages/database/database_service.dart';
import 'package:world_time_app/pages/enums/gender.dart';
import 'package:world_time_app/pages/models/student.dart';
import 'package:world_time_app/pages/registerForm.dart';

class ProfileForm extends StatefulWidget {
  final Student student;
  const ProfileForm({super.key, required this.student});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();
  Gender gender = Gender.male;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  int selectedLevel = 1;
  String _imagePath = '';
  File? _image;
  String imageDecoded = '';

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

    nameController.text = widget.student.name;
    emailController.text = widget.student.email;
    passwordController.text = widget.student.password;
    levelController.text = widget.student.level.toString();
    setState(() {
      if (widget.student.gender == 'male') {
        gender = Gender.male;
      } else {
        gender = Gender.female;
      }
      if (widget.student.image != '') {
        String imageInString = widget.student.image;
        var base64Image = base64Decode(imageInString);
        _saveImage(base64Image);
      }
    });
  }

  Future<void> _saveImage(Uint8List imageBytes) async {
    try {
      debugger();
      final String tempPath = (await getTemporaryDirectory()).path;
      final String filePath = '$tempPath/avatar.png';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageBytes);
      setState(() {
        _image = imageFile;
      });
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  Future getImage(ImageSource source) async {
    debugger();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imagePath = _image!.path;

        Uint8List imageBytes = _image!.readAsBytesSync();

        String base64Image = base64Encode(imageBytes);
        imageDecoded = base64Image;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return AlertDialog(
                      title: Text('Change Profile Photo'),
                      content: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Take Photo'),
                            onTap: () {
                              Navigator.pop(context);
                              getImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Choose from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              getImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: CircleAvatar(
              radius: 60,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null ? Icon(Icons.add_a_photo, size: 40) : null,
            ),
          ),
          SizedBox(
            height: 40,
          ),
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
                return 'Name cannot be empty';
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
            enabled: false,

            // initialValue: student.email,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Email',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            // initialValue: student.password,
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
                return 'Password cannot be empty';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            // initialValue: student.level.toString(),
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
              if (value!.isEmpty) {
                value = 1.toString();
              }
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
                print(levelController.value.text);
                print(gender.name);
                // Validate returns true if the form is valid, or false otherwise.
                debugger();
                if (_formKey.currentState!.validate()) {
                  try {
                    int id = await studentDb.update(
                      name: nameController.value.text,
                      email: emailController.value.text,
                      level: int.parse(levelController.value.text),
                      password: passwordController.value.text,
                      gender: gender.name,
                      image: imageDecoded,
                    );
                    Student student = await studentDb
                        .fetchByEmail('20200330@stud.fci-cu.edu.eg');
                    print('output id: $id');
                    print(student.name);
                    print(student.password);
                  } catch (e) {
                    print(e);
                  }

                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Your account has been updated successfully'),
                      backgroundColor: Color.fromARGB(255, 45, 207, 129),
                      duration: Duration(seconds: 3),
                      showCloseIcon: true,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update your account'),
                      backgroundColor: Color.fromARGB(255, 207, 45, 45),
                      duration: Duration(seconds: 3),
                      showCloseIcon: true,
                    ),
                  );
                }
              },
              child: Text(
                'Update',
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
