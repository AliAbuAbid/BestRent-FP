// ignore_for_file: unused_local_variable, must_be_immutable, unused_import, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Flexible(
          child: user == null
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(child: Text('63'.tr)),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('email', isEqualTo: user!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(child: Text('131'.tr)),
                      );
                    }

                    var documents = snapshot.data!.docs;
                    List<Widget> cards = [];

                    snapshot.data!.docs.forEach((document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      final bool isRead = data['read'] == true;

                      cards.add(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['msgKey'] != null
                                          ? data['msgKey'].toString().tr
                                          : (data['msg'] ?? '').toString(),
                                      style: TextStyle(
                                        color: isRead
                                            ? Colors.grey[500]
                                            : Colors.black,
                                        fontWeight: isRead
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      (data['time'] ?? '').toString(),
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              if (!isRead)
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.check_circle_outline,
                                      color: Colors.green, size: 20),
                                  onPressed: () async {
                                    await document.reference
                                        .update({'read': true});
                                  },
                                ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.close,
                                    color: Colors.red, size: 20),
                                onPressed: () async {
                                  await document.reference.delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                      cards.add(
                          const Divider(color: Colors.grey, thickness: 0.5));
                    });

                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: cards,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
