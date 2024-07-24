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
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Signature(
              controller: _controller,
              height: 190,
              width: double.infinity,
              backgroundColor: Color.fromARGB(82, 205, 205, 206),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  child: Text('37'.tr),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      final signature = await _controller.toPngBytes();
                      if (signature != null) {
                        _uploadSignature(signature);

                        _controller.clear();
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text('189'.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
