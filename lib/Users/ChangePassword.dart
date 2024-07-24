// ignore_for_file: unused_local_variable, unused_import

import 'package:derot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:derot/DataBase/Transition.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validators/validators.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key}) : super(key: key);

  @override
  State<ForgetPage> createState() => forgetScreenState();
}

class forgetScreenState extends State<ForgetPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  @override
  void dispose() {
    _textEditingController.clear();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  Locale initialLang = sharepref!.getString("lang") == "ar"
      ? Locale("ar")
      : (sharepref!.getString("lang") == "en" ? Locale("en") : Locale("he"));

  String? lang = sharepref!.getString("lang");

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final savedEmail = FirebaseAuth.instance.currentUser!.email.toString();
      await FirebaseAuth.instance.setLanguageCode(lang);

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

      Navigator.of(context).pushReplacementNamed('/login');
      //   //isPasswordCorrect = true;
      // } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('72'.tr)),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0).withOpacity(
                  0.5), // Remove 'const' as 'withOpacity' creates a non-constant value
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/houses.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black
                      .withOpacity(0.3), // Apply opacity using ColorFilter
                  BlendMode.dstATop,
                ),
              ),
            ),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.only(top: 100, bottom: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 70, left: 19),
                        child: Text(
                          "115".tr,
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
                                    left: 10, right: 10, top: 10, bottom: 10),
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
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: const BorderSide(
                                color: Color.fromARGB(121, 0, 0, 0),
                                width: 2.0),
                          ),
                          color: Color.fromARGB(99, 255, 255, 255),
                          colorBrightness: Brightness.dark,
                          onPressed: _changePassword,
                          child: Text(
                            '71'.tr,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent, // Make app bar transparent
                elevation: 0, // Remove app bar shadow
              ),
            ],
          ),
        ],
      ),
    );
  }
}
