// // ignore_for_file: unused_element, unused_field, unused_local_variable

// ignore_for_file: unused_field, unused_local_variable, unused_element, unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:derot/Users/login.dart';
//import 'package:derot/DataBase/Transition.dart';
import 'package:get/get.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:validators/validators.dart';

final _firebase = FirebaseAuth.instance;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _form = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController idNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
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

  String? _validateIdNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '75'.tr;
    } else if (value.length < 9 || value.length > 11) {
      return '76'.tr;
    }

    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '77'.tr;
    } else if (value.length != 10) {
      return '78'.tr;
    }

    return null;
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return '79'.tr;
    } else if (value.isNum) {
      return '80'.tr;
    }

    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        User? user = FirebaseAuth.instance.currentUser;

        await firestore.collection('users').add({
          'username': username.text,
          'email': email.text,
          'phone': phone.text,
          'idNumber': idNumber.text,
          'profilePhoto': null,
          'uid': user?.uid,
        });

        Navigator.of(context).pushReplacementNamed('/login');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('81'.tr)),
          );
          print('81'.tr);
        }
      } catch (e) {
        print(e);
      }
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
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0).withOpacity(
              0.6), // Remove 'const' as 'withOpacity' creates a non-constant value
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie.network(
                  //   'https://assets6.lottiefiles.com/packages/lf20_k9wsvzgd.json',
                  //   animate: true,
                  //   height: 120,
                  //   width: 600,
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
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
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  labelText: '17'.tr,
                                  hintText: 'name family',
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
                                validator: _validateFullName,
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
                                validator: _validatePhoneNumber,
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
                                validator: _validateIdNumber,
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
                                controller: email,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  labelText: '18'.tr,
                                  hintText: 'your-email@domain.com',
                                  prefixIcon: Icon(
                                    Icons.email,
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
                            padding: const EdgeInsets.only(left: 20, right: 20),
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
                  Column(
                    children: [
                      Container(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: const BorderSide(
                                color: Color.fromARGB(228, 0, 0, 0),
                                width: 2.0),
                          ),
                          color: Color.fromARGB(141, 255, 255, 255),
                          colorBrightness: Brightness.dark,
                          onPressed: _register, //() {
                          //   Navigator.of(context)
                          //       .pushReplacementNamed('/login');
                          // },
                          child: Text(
                            '16'.tr,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '19'.tr,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: Text(
                          '7'.tr,
                          style: const TextStyle(
                            // color: Color.fromARGB(232, 20, 0, 243),
                            color: Color.fromARGB(255, 178, 189, 224),

                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            //decorationColor: Color.fromARGB(255, 2, 241, 133),
                            decorationThickness: 2.0,
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
