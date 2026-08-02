import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:derot/login11.dart';
import 'package:derot/ChattingApp/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chats extends StatefulWidget {
  @override
  _Chats createState() => _Chats();
}

class _Chats extends State<Chats> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('9'.tr),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 1.0,
            color: Colors.grey, // Change color as per your requirement
          ),
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    final String currentUid = _auth.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatThreads')
          .where('participants', arrayContains: currentUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('204'.tr);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final threads = snapshot.data!.docs;
        if (threads.isEmpty) {
          return Center(child: Text('206'.tr));
        }
        return ListView(
          children: threads
              .map<Widget>((doc) => _buildThreadItem(doc, currentUid))
              .toList(),
        );
      },
    );
  }

  Widget _buildThreadItem(DocumentSnapshot doc, String currentUid) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    List<String> participants = List<String>.from(data['participants'] ?? []);
    final String otherUid = participants.firstWhere(
      (id) => id != currentUid,
      orElse: () => '',
    );
    if (otherUid.isEmpty) return const SizedBox.shrink();

    final int unreadCount =
        (data['unreadCount_$currentUid'] as num?)?.toInt() ?? 0;

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: otherUid)
          .limit(1)
          .get(),
      builder: (context, userSnap) {
        if (!userSnap.hasData || userSnap.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        Map<String, dynamic> userData =
            userSnap.data!.docs.first.data() as Map<String, dynamic>;
        return Column(
          children: [
            ListTile(
              title: Text(userData['username'] ?? ''),
              trailing: unreadCount > 0 ? _buildBadge(unreadCount) : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverUserEmail: userData['email'],
                      receiverUserID: otherUid,
                      receiverUsername: userData['username'],
                    ),
                  ),
                );
              },
            ),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          ],
        );
      },
    );
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      constraints: const BoxConstraints(minWidth: 20),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
