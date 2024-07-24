// ignore_for_file: unused_local_variable, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/DataBase/sharedPrefences.dart';
import 'package:flutter/material.dart';
//import 'package:derot/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:validators/validators.dart';

class DeleteUsers extends StatefulWidget {
  const DeleteUsers({Key? key}) : super(key: key);

  @override
  State<DeleteUsers> createState() => DeleteUser();
}

class DeleteUser extends State<DeleteUsers> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoggedIn = false;

  @override
  void dispose() {
    _textEditingController.clear();
    super.dispose();
  }

  bool isEmailCorrect = false;
  bool isPasswordCorrect = false;
  final _formKey = GlobalKey<FormState>();
  void DeleteAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get the current user
        final user = FirebaseAuth.instance.currentUser;
        final savedEmail = FirebaseAuth.instance.currentUser!.email.toString();

        if (user != null) {
          // Create the AuthCredential for reauthentication
          if (email.text == savedEmail) {
            AuthCredential credential = EmailAuthProvider.credential(
                email: email.text, password: password.text);

            // Reauthenticate the user with the provided credentials
            await user.reauthenticateWithCredential(credential);
            CollectionReference users =
                FirebaseFirestore.instance.collection('users');
            await users.doc('riAPUL7CtZ2qntWn8Rf6').delete();

            await user.delete();
            await FirebaseAuth.instance.signOut();
            SharedPreferencesService.setLoggedIn(false);
            SnackBar(content: Text('84'.tr));
            Navigator.of(context).pushReplacementNamed('/home');
          }

          // Navigator.of(context).push(CustomPageRoute(
          //   pageBuilder: (context) => LoginPage(),
          // ));
          print('User account deleted successfully.');
        } else {
          print('No user is currently signed in.');
        }
      } catch (e) {
        print('Failed to delete user account: $e');
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '65'.tr;
    } else if (!isEmail(value)) {
      return '66'.tr;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '67'.tr;
    } else if (value.length < 6) {
      return '68'.tr;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0).withOpacity(
              0.5), // Remove 'const' as 'withOpacity' creates a non-constant value
          image: DecorationImage(
            image: AssetImage(
              'assets/images/houses.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Apply opacity using ColorFilter
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Container(
          child: Container(
            height: MediaQuery.of(context).size.height,

            //padding: EdgeInsets.only(bottom: 272),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppBar(
                        backgroundColor:
                            Colors.transparent, // Make app bar transparent
                        elevation: 0, // Remove app bar shadow
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 40, left: 40),
                    child: Text(
                      "116".tr,
                      style: GoogleFonts.lato(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      //textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20, top: 20),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: TextFormField(
                                  controller: email,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    labelText: '18'.tr,
                                    hintText: 'your-email@domain.com',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Color.fromARGB(232, 0, 0, 0),
                                    ),
                                    labelStyle: TextStyle(
                                        color: Color.fromARGB(201, 0, 0, 0),
                                        fontSize: 16),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                  ),
                                  validator: _validateEmail,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: TextFormField(
                                  controller: password,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    labelText: '13'.tr,
                                    hintText: '*********',
                                    prefixIcon: Icon(
                                      Icons.lock_open,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                  ),
                                  validator: _validatePassword,
                                  obscureText: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            //margin: EdgeInsets.only(left: 110, right: 107),
                            child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: const BorderSide(
                                      color: Color.fromARGB(121, 0, 0, 0),
                                      width: 2.0),
                                ),
                                color: Color.fromARGB(134, 255, 255, 255),
                                colorBrightness: Brightness.dark,
                                onPressed: () {
                                  DeleteAccount();
                                },
                                child: Row(
                                  children: [
                                    SizedBox(width: 28),
                                    Text(
                                      '83'.tr,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 28),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
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
