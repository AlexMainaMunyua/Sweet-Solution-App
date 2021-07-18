import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Authentication/login.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/DialogBox/errorDialog.dart';
import 'package:ecommerce_application/pages/DialogBox/loadingAlertDialog.dart';
import 'package:ecommerce_application/pages/Widgets/CustomTextField.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'package:firebase_storage/firebase_storage.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userImageUrl = "";

  File? _imageFile;

  bool _obscureText = true;

  bool _obscureTextC = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureTextC = !_obscureTextC;
    });
  }

  Future<bool> _onWillPop() async {
    Route route = MaterialPageRoute(builder: (c) => Login());

    Navigator.pushReplacement(context, route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () => _onWillPop(),

      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 50,
                    child: Center(
                      child: Text("Register",
                          style: TextStyle(
                              fontSize: 45.0,
                              color: Colors.grey.shade500,
                              fontFamily: "Signatra")),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  InkWell(
                    onTap: () {
                      _selectAndPickImage();
                    },
                    child: CircleAvatar(
                      radius: _screenHeight * 0.06,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          _imageFile == null ? null : FileImage(_imageFile!),
                      child: _imageFile == null
                          ? Icon(Icons.add_photo_alternate,
                              size: _screenWidth * 0.10, color: Colors.grey)
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameTextEditingController,
                          data: Icons.person,
                          hintText: "Name",
                          isObsecure: false,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _emailTextEditingController,
                            obscureText: false,
                            validator: Validators.compose([
                              Validators.email("Invalid Email Address"),
                              Validators.patternString(
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
                                  'Invalid Email Address')
                            ]),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                              focusColor: Theme.of(context).primaryColor,
                              hintText: "Email",
                            ),
                          ),
                        ),
                        // CustomTextField(
                        //   controller: _emailTextEditingController,
                        //   data: Icons.email,
                        //   hintText: "Email",

                        //   isObsecure: false,
                        // ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              TextFormField(
                                controller: _passwordTextEditingController,
                                obscureText: _obscureText,
                                validator: Validators.compose([
                                  Validators.required("Password is required"),
                                  Validators.patternString(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                      'Invalid Password')
                                ]),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  focusColor: Theme.of(context).primaryColor,
                                  hintText: "password",
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.remove_red_eye
                                          : Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    ),
                                    onPressed: _toggle,
                                  ))
                            ],
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              TextFormField(
                                controller: _cPasswordTextEditingController,
                                obscureText: _obscureTextC,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  focusColor: Theme.of(context).primaryColor,
                                  hintText: "Confirm password",
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(
                                      _obscureTextC
                                          ? Icons.remove_red_eye
                                          : Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    ),
                                    onPressed: _toggle2,
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          uploadAndSaveImage();
                        },
                        child: Text("Sign up",
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                          onPressed: () {
                            Route route =
                                MaterialPageRoute(builder: (c) => Login());

                            Navigator.pushReplacement(context, route);
                          },
                          child: Text("Have an account? Log In"))
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.8,
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    // _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: "please select an Image file.");
          });
    } else {
      _passwordTextEditingController.text ==
              _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cPasswordTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("Please fill up the registration from.")
          : displayDialog("Password do not match.");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: msg);
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Registering, Please wait....",
          );
        });

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child(imageFileName);

    UploadTask uploadTask = ref.putFile(_imageFile!);

    uploadTask.whenComplete(() async {
      userImageUrl = await ref.getDownloadURL();

      _registerUser();
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    return userImageUrl;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    User? firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser!).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => MyHomePage());

        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      SweetSolution.userCartList: ["garbageValue"],
    });

    await SweetSolution.sharedPreferences
        .setString(SweetSolution.userUID, fUser.uid);
    await SweetSolution.sharedPreferences
        .setString(SweetSolution.userEmail, fUser.email!);
    await SweetSolution.sharedPreferences.setString(
        SweetSolution.userName, _nameTextEditingController.text.trim());
    await SweetSolution.sharedPreferences
        .setString(SweetSolution.userAvatarUrl, userImageUrl);
    await SweetSolution.sharedPreferences
        .setStringList(SweetSolution.userCartList, ["garbageValue"]);
  }
}
