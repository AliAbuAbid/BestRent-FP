// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignatureScreen extends StatefulWidget {
  String docId;
  SignatureScreen({super.key, required this.docId});
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<String?> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          String username = data['username'];
          return username;
        } else {
          print('');
          return null;
        }
      } catch (e) {
        print('Error getting username: $e');
        return null;
      }
    } else {
      print('No user signed in.');
      return null;
    }
  }

  Future<void> _uploadSignature(Uint8List signature) async {
    User? user = FirebaseAuth.instance.currentUser;
    String username = '';

    if (user != null) {
      String uid = user.uid;

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          username = data['username'];
        } else {
          print('');
          return null;
        }
      } catch (e) {
        print('Error getting username: $e');
        return null;
      }
    } else {
      print('No user signed in.');
      return null;
    }
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('pdfs/${widget.docId}/signatures/"$username".png');
      await storageRef.putData(signature);
      final downloadUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('inProgress')
          .doc(widget.docId)
          .update({
        '$username': true,
      });
    } catch (e) {
      print('Failed to upload signature: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '172'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Signature(
            controller: _controller,
            height: 190,
            width: double.infinity,
            backgroundColor:
                isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F1),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _controller.clear();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '37'.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 46,
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
                      onTap: () async {
                        if (_controller.isNotEmpty) {
                          final signature = await _controller.toPngBytes();
                          if (signature != null) {
                            _uploadSignature(signature);

                            _controller.clear();
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Center(
                        child: Text(
                          '189'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
