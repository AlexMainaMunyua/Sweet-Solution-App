import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Admin/adminSignInPage.dart';
import 'package:ecommerce_application/pages/Authentication/forgotPassword.dart';
import 'package:ecommerce_application/pages/Authentication/register.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/DialogBox/errorDialog.dart';
import 'package:ecommerce_application/pages/DialogBox/loadingAlertDialog.dart';
import 'package:ecommerce_application/pages/Widgets/CustomTextField.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'registerwithphone.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are you sure?"),
              content: Text("Do you want to exit the application."),
              actions: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text(
                    "No",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(width: 30.0, height: 30),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text(
                    "Yes",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //             colors: [Colors.black26, Colors.white],
        //             begin: const FractionalOffset(0.0, 0.0),
        //             end: const FractionalOffset(1.0, 0.0),
        //             stops: [0.0, 1.0],
        //             tileMode: TileMode.clamp)),
        //   ),
        //   title: Text(
        //     "Login",
        //     style: TextStyle(
        //         fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
        //   ),
        //   centerTitle: true,
        // ),
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
                    padding: EdgeInsets.only(top: 10.0),
                    height: 50,
                    child: Center(
                      child: Text("LOGIN",
                          style: TextStyle(
                              fontSize: 45.0,
                              color: Colors.grey.shade500,
                              fontFamily: "Signatra")),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("images/login.png"),
                    height: 200.0,
                    width: 240.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Login to your account",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailTextEditingController,
                          data: Icons.email,
                          hintText: "Email",
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
                          child: Stack(
                            children: [
                              TextFormField(
                                controller: _passwordTextEditingController,
                                obscureText: _obscureText,
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
                        )
                        // CustomTextField(
                        //   controller: _passwordTextEditingController,
                        //   data: Icons.lock,
                        //   hintText: "Password",
                        //   isObsecure: true,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (c) => Register());

                          Navigator.pushReplacement(context, route);
                        },
                        child: Text("Sign up",
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _emailTextEditingController.text.isNotEmpty &&
                                  _passwordTextEditingController.text.isNotEmpty
                              ? loginUser()
                              : showDialog(
                                  context: context,
                                  builder: (c) {
                                    return ErrorAlertDialog(
                                        message:
                                            "Please write email and password.");
                                  });
                          // uploadAndSaveImage();
                        },
                        child: Text("Log in",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (c) => ForgotPassword());

                            Navigator.pushReplacement(context, route);
                          },
                          child: Text("Forgot Password ?")),
                      TextButton(
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (c) => LoginScreen());

                            Navigator.pushReplacement(context, route);
                          },
                          child: Text("Phone number")),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.8,
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextButton.icon(
                    icon: (Icon(
                      Icons.nature_people,
                      color: Colors.black26,
                    )),
                    label: Text(
                      'Admin',
                      style: TextStyle(
                          color: Colors.black26, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminSignInPage())),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authentication, please wait",
          );
        });

    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    // });
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
    if (User != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => MyHomePage());

        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(User user) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userUID, dataSnapshot.data()[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data()[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data()[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data()[EcommerceApp.userAvatarUrl]);

      List<String> cartList =
          dataSnapshot.data()[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
