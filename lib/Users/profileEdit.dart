// // ignore_for_file: unused_element, unused_field, unused_local_variable

// ignore_for_file: unused_field, unused_local_variable, unused_element, unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:derot/Users/login.dart';
//import 'package:derot/DataBase/Transition.dart';
import 'package:get/get.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:lottie/lottie.dart';
import 'package:validators/validators.dart';

final _firebase = FirebaseAuth.instance;

class EditUser extends StatefulWidget {
  @override
  EditInfo createState() => EditInfo();
}

class EditInfo extends State<EditUser> {
  final _form = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  // TextEditingController email = TextEditingController();
  //TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController idNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return '65'.tr;
  //   } else if (!isEmail(value)) {
  //     return '66'.tr;
  //   }

  //   return null;
  // }

  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return '67'.tr;
  //   } else if (value.length < 6) {
  //     return '68'.tr;
  //   }

  //   return null;
  // }

  // String? _validateIdNumber(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return '75'.tr;
  //   } else if (value.length < 9 || value.length > 11) {
  //     return '76'.tr;
  //   }

  //   return null;
  // }

  // String? _validatePhoneNumber(String value) {
  //   // if (value == null || value.isEmpty) {
  //   //   return '77'.tr;
  //   // } else
  //    if (value.length != 10) {
  //     return '78'.tr;
  //   }

  //   return null;
  // }

  // String? _validateFullName(String value) {
  //   // if (value == null || value.isEmpty) {
  //   //   return '79'.tr;
  //   // }
  //    if (value.isNum) {
  //     return '80'.tr;
  //   }

  //   return null;
  // }
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> _update() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    String docsId = querySnapshot.docs.first.id;

    print('\n\n\n\n\n\n$docsId\n\n\n\n\n\n');

    if (username.text != '' && idNumber.text != '' && phone.text != '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('107'.tr)));
      return users
          .doc(docsId)
          .update({
            'username': username.text,
            'idNumber': idNumber.text,
            'phone': phone.text
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (username.text != '' && idNumber.text != '' && phone.text == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('107'.tr)));
      return users
          .doc(docsId)
          .update({
            'username': username.text,
            'idNumber': idNumber.text,
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (username.text != '' && idNumber.text == '' && phone.text != '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('72'.tr)));
      return users
          .doc(docsId)
          .update({'username': username.text, 'phone': phone.text})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (username.text == '' && idNumber.text != '' && phone.text != '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('107'.tr)));
      return users
          .doc(docsId)
          .update({'idNumber': idNumber.text, 'phone': phone.text})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (username.text == '' && idNumber.text == '' && phone.text != '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('72'.tr)));
      return users
          .doc(docsId)
          .update({'phone': phone.text})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (username.text == '' && idNumber.text != '' && phone.text == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('107'.tr)));
      return users
          .doc(docsId)
          .update({'idNumber': idNumber.text})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (username.text != '' && idNumber.text == '' && phone.text == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('107'.tr)));
      return users
          .doc(docsId)
          .update({'username': username.text})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (username.text == '' && idNumber.text == '' && phone.text == '') {
      print('No thing has changed');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('108'.tr)));
    }
  }

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredPhone = '';
  var _enteredUsername = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0).withOpacity(
              0.5), // Remove 'const' as 'withOpacity' creates a non-constant value
          image: DecorationImage(
            image: AssetImage(
              'assets/images/beersheva.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), // Apply opacity using ColorFilter
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      AppBar(
                        backgroundColor:
                            Colors.transparent, // Make app bar transparent
                        elevation: 0, // Remove app bar shadow
                      ),
                    ],
                  ),
                  Container(
                    //alignment: Alignment.bottomRight,
                    height: 120,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                                  controller: username,
                                  //initialValue: 'ali abu abid',
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    labelText: '17'.tr,
                                    //hintText: 'name family',
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
                                  //   validator: _validateFullName,
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
                                  controller: phone,
                                  //initialValue: '0549927489',
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: '73'.tr,
                                    hintText: '012-3456789',
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Color.fromARGB(232, 0, 0, 0),
                                    ),
                                    labelStyle: TextStyle(
                                        color: Color.fromARGB(201, 0, 0, 0),
                                        fontSize: 16),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                  ),
                                  // validator: _validatePhoneNumber,
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
                                  controller: idNumber,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: '74'.tr,
                                    hintText: '012345678',
                                    prefixIcon: Icon(
                                      Icons.contact_emergency_rounded,
                                      color: Color.fromARGB(232, 0, 0, 0),
                                    ),
                                    labelStyle: TextStyle(
                                        color: Color.fromARGB(201, 0, 0, 0),
                                        fontSize: 16),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                  ),
                                  //validator: _validateIdNumber,
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     left: 20,
                            //     right: 20,
                            //   ),
                            //   child: Container(
                            //     margin: EdgeInsets.all(5),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //       color: Color.fromARGB(255, 255, 255, 255),
                            //     ),
                            //     child: TextFormField(
                            //       controller: email,
                            //       textAlign: TextAlign.left,
                            //       decoration: InputDecoration(
                            //         labelText: '18'.tr,
                            //         hintText: 'your-email@domain.com',
                            //         prefixIcon: Icon(
                            //           Icons.email,
                            //           color: Color.fromARGB(232, 0, 0, 0),
                            //         ),
                            //         labelStyle: TextStyle(
                            //             color: Color.fromARGB(201, 0, 0, 0),
                            //             fontSize: 16),
                            //         border: InputBorder.none,
                            //         contentPadding: EdgeInsets.symmetric(
                            //             horizontal: 20, vertical: 8),
                            //       ),
                            //       //  validator: _validateEmail,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: const BorderSide(
                                color: Color.fromARGB(121, 0, 0, 0),
                                width: 2.0),
                          ),
                          color: Color.fromARGB(110, 255, 255, 255),
                          colorBrightness: Brightness.dark,
                          onPressed: _update, //() {
                          //   Navigator.of(context)
                          //       .pushReplacementNamed('/login');
                          // },
                          child: Text(
                            '86'.tr,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
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
