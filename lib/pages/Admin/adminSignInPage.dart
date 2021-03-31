import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Admin/uploadItems.dart';
import 'package:ecommerce_application/pages/Authentication/authenication.dart';
import 'package:ecommerce_application/pages/DialogBox/errorDialog.dart';
import 'package:ecommerce_application/pages/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black26, Colors.white],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        title: Text(
          "P-shop",
          style: TextStyle(
              fontSize: 20.0, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
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
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black26, Colors.white],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset("images/admin.png"),
              height: 240.0,
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
                    color: Colors.white),
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
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: "password",
                    isObsecure: true,
                  ),
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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AuthenticScreen())),
            )
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
