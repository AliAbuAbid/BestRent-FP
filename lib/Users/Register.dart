// // ignore_for_file: unused_element, unused_field, unused_local_variable

// ignore_for_file: unused_field, unused_local_variable, unused_element, unused_import, deprecated_member_use
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
  static const Color _accent = Color(0xFF0D47A1);

  final _form = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController idNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          labelText: label,
          labelStyle:
              TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600),
          prefixIcon: Icon(icon, color: _accent),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text('16'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_alt_outlined,
                      size: 38, color: _accent),
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      controller: username,
                      label: '17'.tr,
                      icon: Icons.person_outline,
                      isDark: isDark,
                      validator: _validateFullName,
                    ),
                    _buildField(
                      controller: phone,
                      label: '73'.tr,
                      icon: Icons.phone_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.number,
                      validator: _validatePhoneNumber,
                    ),
                    _buildField(
                      controller: idNumber,
                      label: '74'.tr,
                      icon: Icons.badge_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.number,
                      validator: _validateIdNumber,
                    ),
                    _buildField(
                      controller: email,
                      label: '18'.tr,
                      icon: Icons.email_outlined,
                      isDark: isDark,
                      validator: _validateEmail,
                    ),
                    _buildField(
                      controller: password,
                      label: '13'.tr,
                      icon: Icons.lock_outline,
                      isDark: isDark,
                      obscureText: _obscureText,
                      validator: _validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF26C6DA)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _register,
                      child: Center(
                        child: Text(
                          '16'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '19'.tr,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Text(
                      '7'.tr,
                      style: const TextStyle(
                        color: _accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
