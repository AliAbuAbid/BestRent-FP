// // ignore_for_file: unused_element, unused_field, unused_local_variable

// ignore_for_file: unused_field, unused_local_variable, unused_element, unused_import, deprecated_member_use
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
  static const Color _accent = Color(0xFF0D47A1);

  final _form = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  // TextEditingController email = TextEditingController();
  //TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController idNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('85'.tr),
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
                  child: const Icon(Icons.person_outline,
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
                    ),
                    _buildField(
                      controller: phone,
                      label: '73'.tr,
                      icon: Icons.phone_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.number,
                    ),
                    _buildField(
                      controller: idNumber,
                      label: '74'.tr,
                      icon: Icons.badge_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.number,
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
                      onTap: _update,
                      child: Center(
                        child: Text(
                          '86'.tr,
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
            ],
          ),
        ),
      ),
    );
  }
}
