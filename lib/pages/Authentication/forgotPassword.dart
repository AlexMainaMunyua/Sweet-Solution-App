import 'package:ecommerce_application/pages/Authentication/login.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late String _email;

  final _auth = FirebaseAuth.instance;

  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => Login());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _onWillPop(context);
      } as Future<bool> Function()?,
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
                    height: 70,
                    child: Center(
                      child: Text("Forgot Password",
                          style: TextStyle(
                              fontSize: 45.0,
                              color: Colors.grey.shade500,
                              fontFamily: "Signatra")),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Please put you email address",
                          style: TextStyle(color: Colors.grey.shade500),
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        TextFormField(
                          // controller: _passwordTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              _email = value.trim();
                            });
                          },

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                            focusColor: Theme.of(context).primaryColor,
                            hintText: "Email address",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: WideButton(
                      msg: "RESET",
                      onPressed: () {
                        _auth.sendPasswordResetEmail(email: _email);

                        Route route =
                            MaterialPageRoute(builder: (c) => Login());

                        Navigator.pushReplacement(context, route);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Please check your email address to reset your password")));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Route route =
                                MaterialPageRoute(builder: (c) => Login());

                            Navigator.pushReplacement(context, route);
                          },
                          child: Text(
                            "Go back to login Page",
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
