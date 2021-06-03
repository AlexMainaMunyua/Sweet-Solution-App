import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Admin/uploadItems.dart';
import 'package:ecommerce_application/pages/Authentication/loginwithphone.dart';
import 'package:ecommerce_application/pages/DialogBox/errorDialog.dart';
import 'package:ecommerce_application/pages/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: AdminSignInScreen()),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDTextEditingController =
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

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
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
                child: Text("Cady administrator",
                    style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.grey.shade500,
                        fontFamily: "Signatra")),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset("images/admin.png"),
              height: 200.0,
              width: 240.0,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    color: Colors.grey.shade400),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: "ID",
                    isObsecure: false,
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
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              onPressed: () {
                _adminIDTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                              message: "Please write email and password.");
                        });
                // uploadAndSaveImage();
              },
              child: Text("Log in", style: TextStyle(color: Colors.white)),
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
              height: 5.0,
            ),
            TextButton.icon(
                icon: (Icon(
                  Icons.nature_people,
                  color: Colors.black26,
                )),
                label: Text(
                  'User',
                  style: TextStyle(
                      color: Colors.black26, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Route route =
                      MaterialPageRoute(builder: (c) => LoginScreen());

                  Navigator.pushReplacement(context, route);
                })
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("admins").get().then((snapshot) {
      snapshot.docs.forEach((element) {
        if (element.data()["id"] != _adminIDTextEditingController.text.trim()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Your ID is not correct")));
        } else if (element.data()["password"] !=
            _passwordTextEditingController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Your password is not correct")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Welcome Dear Admin, " + element.data()["name"])));

          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });

          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c) => UploadPage());

          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
