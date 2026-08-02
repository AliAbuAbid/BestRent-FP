// ignore_for_file: unused_local_variable, unused_import, deprecated_member_use

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
  static const Color _accent = Color(0xFF0D47A1);

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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark
                ? const Color.fromARGB(31, 252, 2, 2)
                : Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
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
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('82'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
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
                    child:
                        const Icon(Icons.lock_reset, size: 38, color: _accent),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '115'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                Form(
                  key: _formKey,
                  child: _buildField(
                    controller: email,
                    label: '18'.tr,
                    icon: Icons.email_outlined,
                    isDark: isDark,
                    validator: _validateEmail,
                  ),
                ),
                const SizedBox(height: 22),
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
                        onTap: _changePassword,
                        child: Center(
                          child: Text(
                            '71'.tr,
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
      ),
    );
  }
}
