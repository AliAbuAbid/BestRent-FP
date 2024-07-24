// ignore_for_file: unused_local_variable, unused_import

import 'package:connectivity/connectivity.dart';
import 'package:derot/Home.dart';
import 'package:derot/Users/ChangePassword.dart';
import 'package:flutter/material.dart';
import 'package:derot/DataBase/Transition.dart';
//import 'package:derot/Home.dart';
import 'package:derot/DataBase/sharedPrefences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validators/validators.dart';
import 'package:derot/DataBase/internetConnection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => loginScreenState();
}

class loginScreenState extends State<LoginPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void check = InternetCheckWidget;

  // bool _isConnected = true;
  // Future<void> _checkConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   setState(() {
  //     _isConnected = connectivityResult != ConnectivityResult.none;
  //   });
  // }

  @override
  void dispose() {
    _textEditingController.clear();
    super.dispose();
  }

  bool isEmailCorrect = false;
  bool isPasswordCorrect = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text, password: password.text);

        SharedPreferencesService.setLoggedIn(true);
        Navigator.of(context).pushReplacementNamed('/home');
        //isPasswordCorrect = true;
      } on FirebaseAuthException catch (e) {
        isEmailCorrect = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('64'.tr)),
        );
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
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
        // width: 400,
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
          //padding: EdgeInsets.only(bottom: 207.4),
          child: Column(
            children: [
              Column(
                children: [
                  SafeArea(
                    child: AppBar(
                      //shadowColor: Color.fromARGB(0, 133, 133, 133),
                      backgroundColor: Color.fromARGB(0, 255, 255, 255),
                      elevation: 0.0,
                    ),
                  ),
                ],
              ),
              Container(
                child: SafeArea(
                  // padding: EdgeInsets.only(bottom: 207),
                  // scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Lottie.network(
                      //   'https://assets6.lottiefiles.com/packages/lf20_k9wsvzgd.json',
                      //   animate: true,
                      //   height: 120,
                      //   width: 600,
                      // ),

                      Image.asset(
                        'assets/icons/login1.gif',
                        width: 90, // Adjust width as needed
                        height: 90,
                        // Adjust height as needed
                      ),
                      // SizedBox(
                      //   height: 70,
                      // ),
                      Text(
                        '7'.tr,
                        style: GoogleFonts.indieFlower(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 252, 252)
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10, top: 10),
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
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  child: TextFormField(
                                    // obscureText: _obscureText,
                                    controller: password,
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                      labelText: '13'.tr,
                                      hintText: '*********',
                                      prefixIcon: Icon(
                                        Icons.lock_open,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            //_togglePasswordVisibility();
                                            _obscureText = !_obscureText;
                                          });
                                        },
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
                                    obscureText: _obscureText,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 20),
                                  Container(
                                    //   margin: EdgeInsets.only(right: 10),
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          side: const BorderSide(
                                              color:
                                                  Color.fromARGB(121, 0, 0, 0),
                                              width: 2.0),
                                        ),
                                        // color:
                                        //     Color.fromARGB(209, 52, 124, 207),
                                        colorBrightness: Brightness.dark,
                                        onPressed: _login,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 28),
                                            Text(
                                              '123'.tr,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 28),
                                          ],
                                        )),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(CustomPageRoute(
                                          pageBuilder: (context) =>
                                              ForgetPage(),
                                        ));
                                      },
                                      child: Row(
                                        children: [
                                          //SizedBox(width: 155),
                                          Text(
                                            '14'.tr,
                                            style: const TextStyle(
                                              // color: Color.fromARGB(232, 20, 0, 243),
                                              color:
                                                  Color.fromARGB(197, 2, 1, 1),
                                              fontWeight: FontWeight.bold,
                                              decorationThickness: 2.0,
                                            ),
                                          ),
                                        ],
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
                                    '15'.tr,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('register');
                                    },
                                    child: Text(
                                      '16'.tr,
                                      style: const TextStyle(
                                        // color: Color.fromARGB(232, 20, 0, 243),
                                        color: Color.fromARGB(255, 76, 0, 255),

                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        //decorationColor: Color.fromARGB(255, 2, 241, 133),
                                        decorationThickness: 2.0,
                                      ),
                                    ),
                                  ),
                                ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Container(
                              //   //margin: EdgeInsets.only(left: 110, right: 107),
                              //   child: MaterialButton(
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(100),
                              //         side: const BorderSide(
                              //             color: Color.fromARGB(121, 0, 0, 0),
                              //             width: 2.0),
                              //       ),
                              //       color: Color.fromARGB(209, 52, 124, 207),
                              //       colorBrightness: Brightness.dark,
                              //       onPressed: _login,
                              //       child: Row(
                              //         children: [
                              //           SizedBox(width: 28),
                              //           Text(
                              //             '7'.tr,
                              //             style: const TextStyle(
                              //                 color:
                              //                     Color.fromARGB(255, 0, 0, 0),
                              //                 fontSize: 20,
                              //                 fontWeight: FontWeight.bold),
                              //           ),
                              //           SizedBox(width: 28),
                              //         ],
                              //       )),
                              // ),
                            ],
                          ),

                          // Container(
                          //   child: MaterialButton(
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(100),
                          //       side: const BorderSide(
                          //           color: Color.fromARGB(121, 0, 0, 0),
                          //           width: 2.0),
                          //     ),
                          //     color: Color.fromARGB(209, 52, 124, 207),
                          //     colorBrightness: Brightness.dark,
                          //     onPressed: () {
                          //       Navigator.of(context)
                          //           .pushReplacementNamed('/home');
                          //     },
                          //     child: Text(
                          //       '1'.tr,
                          //       style: const TextStyle(
                          //           color: Color.fromARGB(255, 0, 0, 0),
                          //           fontSize: 20,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
