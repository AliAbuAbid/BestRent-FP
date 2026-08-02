// ignore_for_file: unused_local_variable, unused_import, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/DataBase/sharedPrefences.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  static const Color _danger = Colors.redAccent;

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

  // Recursively deletes every file under a Firebase Storage folder.
  Future<void> _deleteStorageFolder(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final result = await ref.listAll();
      for (final item in result.items) {
        await item.delete();
      }
      for (final prefix in result.prefixes) {
        await _deleteStorageFolder(prefix.fullPath);
      }
    } catch (e) {
      print('Error deleting storage folder $path: $e');
    }
  }

  // Deletes every piece of data that belongs to this user across the whole
  // app - apartments they own, in-progress/completed rentals (as owner or as
  // a named renter), favourites, notifications, payments and their profile
  // photo/document - but deliberately leaves the 'chat' and 'chatThreads'
  // collections untouched so conversation history survives for the other
  // participant.
  Future<void> _deleteAllUserData(
      String uid, String userEmail, String? username) async {
    final firestore = FirebaseFirestore.instance;

    // Apartments this user owns.
    try {
      final apartments = await firestore
          .collection('apartments')
          .where('uid', isEqualTo: uid)
          .get();
      for (final doc in apartments.docs) {
        await _deleteStorageFolder('images/${doc.id}');
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting apartments: $e');
    }

    // Rentals (in progress / completed): fully remove the ones this user
    // owns, and just strip this user's name from the ones where they're
    // only listed as a renter alongside other people.
    for (final collectionName in ['inProgress', 'completed']) {
      try {
        final owned = await firestore
            .collection(collectionName)
            .where('uid', isEqualTo: uid)
            .get();
        for (final doc in owned.docs) {
          await _deleteStorageFolder('images/${doc.id}');
          await _deleteStorageFolder('pdfs/${doc.id}');
          await doc.reference.delete();
        }
      } catch (e) {
        print('Error deleting owned $collectionName: $e');
      }

      if (username != null && username.isNotEmpty) {
        try {
          final rented = await firestore
              .collection(collectionName)
              .where(Filter.or(
                  Filter('name1', isEqualTo: username),
                  Filter('name2', isEqualTo: username),
                  Filter('name3', isEqualTo: username),
                  Filter('name4', isEqualTo: username)))
              .get();
          for (final doc in rented.docs) {
            final data = doc.data();
            if (data['uid'] == uid) continue; // already deleted above
            if (data['name1'] == username) {
              await doc.reference.update({'name1': FieldValue.delete()});
            } else if (data['name2'] == username) {
              await doc.reference.update({'name2': FieldValue.delete()});
            } else if (data['name3'] == username) {
              await doc.reference.update({'name3': FieldValue.delete()});
            } else if (data['name4'] == username) {
              await doc.reference.update({'name4': FieldValue.delete()});
            }
          }
        } catch (e) {
          print('Error removing renter references in $collectionName: $e');
        }
      }
    }

    // Favourites (single doc keyed by email).
    try {
      await firestore.collection('favourites').doc(userEmail).delete();
    } catch (e) {
      print('Error deleting favourites: $e');
    }

    // Notifications addressed to this user.
    try {
      final notifications = await firestore
          .collection('notifications')
          .where('email', isEqualTo: userEmail)
          .get();
      for (final doc in notifications.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting notifications: $e');
    }

    // Payments this user made or received.
    try {
      final madePayments = await firestore
          .collection('payments')
          .where('userId', isEqualTo: uid)
          .get();
      for (final doc in madePayments.docs) {
        await doc.reference.delete();
      }
      final receivedPayments = await firestore
          .collection('payments')
          .where('ownerUid', isEqualTo: uid)
          .get();
      for (final doc in receivedPayments.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting payments: $e');
    }

    // Profile photo.
    try {
      await FirebaseStorage.instance
          .ref()
          .child('user_images/$uid.jpg')
          .delete();
    } catch (e) {
      print('Error deleting profile photo: $e');
    }

    // The user's own profile document.
    try {
      final userDocs = await firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();
      for (final doc in userDocs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting user profile: $e');
    }

    // Intentionally not touched: 'chat' (messages) and 'chatThreads' -
    // conversation history is preserved even after account deletion.
  }

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

            final String uid = user.uid;
            String? username;
            try {
              final querySnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', isEqualTo: uid)
                  .limit(1)
                  .get();
              if (querySnapshot.docs.isNotEmpty) {
                username =
                    querySnapshot.docs.first.data()['username'] as String?;
              }
            } catch (e) {
              print('Error fetching username before deletion: $e');
            }

            await _deleteAllUserData(uid, savedEmail, username);

            await user.delete();
            await FirebaseAuth.instance.signOut();
            SharedPreferencesService.setLoggedIn(false);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('84'.tr)),
              );
              Navigator.of(context).pushReplacementNamed('/home');
            }
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('210'.tr)),
            );
          }

          print('User account deleted successfully.');
        } else {
          print('No user is currently signed in.');
        }
      } catch (e) {
        print('Failed to delete user account: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('174'.tr)),
          );
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          labelText: label,
          labelStyle:
              TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600),
          prefixIcon: Icon(icon, color: _danger),
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
        title: Text('83'.tr),
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
                    color: _danger.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      size: 38, color: _danger),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '116'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _danger,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: DeleteAccount,
                      child: Center(
                        child: Text(
                          '83'.tr,
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
