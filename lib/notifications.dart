// ignore_for_file: unused_local_variable, must_be_immutable, unused_import, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final List<String> notifications = [
    "You have a new message",
    "You have a new message",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('130'.tr),
        ),
      ),
      body: user == null
          ? Center(child: Text('63'.tr))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('email', isEqualTo: user!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('131'.tr));
                }

                var documents = snapshot.data!.docs;
                List<Widget> cards = [];

                snapshot.data!.docs.forEach((document) {
                  String address = document['email'];

                  cards.add(
                    ListTile(
                      title: TextButton(
                        onPressed: null,
                        onLongPress: () async {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 80,
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () async {
                                      await document.reference.delete();
                                    },
                                    child: Text(
                                      "126".tr,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  (document['msg']),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            Text(
                              (document['time']),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });

                return ListView(
                  // padding: EdgeInsets.only(top: 65),
                  children: cards,
                );
              },
            ),
    );
  }
}
