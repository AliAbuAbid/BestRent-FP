// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/HouseRent/InProgress/signature.dart';
import 'package:derot/Payment/PaymentPage.dart';
import 'package:derot/Payment/showPayment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';

class ShowOwnContract extends StatefulWidget {
  final String docId;
  //final String signName;
  ShowOwnContract({
    super.key,
    required this.docId,
  });

  @override
  State<ShowOwnContract> createState() => _PDFViewer();
}

class _PDFViewer extends State<ShowOwnContract> {
//  bool signat = false;
  User? user = FirebaseAuth.instance.currentUser;
  String userUid = '';
  Future<List<String>> _getImages(String documentId) async {
    List<String> imageUrls = [];
    Reference imagesRef =
        FirebaseStorage.instance.ref().child('pdfs/$documentId/signatures');
    try {
      ListResult result = await imagesRef.listAll();
      for (Reference ref in result.items) {
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Error loading images: $e');
    }
    return imageUrls;
  }

  void paymntMethod() {
    if (user?.uid == '') {}
  }

  void _showEnlargedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

/////////////////////////////////////////////////////
  String? usernamee;

  Future<void> getUsername() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        setState(() {
          usernamee = documentSnapshot['username'];
        });
      } else {
        print('No user found with the given UID');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> checkPayments() async {
    String ownerId = '12';
    String userId = '12';
    print('lllllllllllllllllllllllllllll ${widget.docId}');
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('inProgress')
            .doc(widget.docId)
            .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data();
      if (data != null) {
        ownerId = data['uid'];
      }
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('payments')
        .where('postId', isEqualTo: widget.docId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      userId = querySnapshot.docs[0].data()['userId'];
      //print('User profile photo: $userProfilePhoto');
    } else {
      print('No user found with the email: ');
    }

    if (ownerId != user?.uid && userId == user?.uid) {
      Navigator.of(context).pushReplacement(
        CustomPageRoute(
          pageBuilder: (context) => PaymentDetails(
            documentId: widget.docId,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => Payment(
          documentId: widget.docId,
        ),
      ));
    }
  }

/////////////////////////////////////////////////////////
  void _showSignatureDialog(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: Column(
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
                SizedBox(
                  height: 170,
                  child: FutureBuilder<List<String>>(
                    future: _getImages(widget.docId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text("${'204'.tr}: ${snapshot.error}"));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(child: Text('205'.tr));
                      } else {
                        return CarouselSlider.builder(
                          itemCount: snapshot.data!.length,
                          options: CarouselOptions(
                            height: 170.0,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: false,
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                          ),
                          itemBuilder: (BuildContext context, int index, _) {
                            return GestureDetector(
                              onTap: () {
                                _showEnlargedImage(
                                    context, snapshot.data![index]);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    snapshot.data![index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((signature) {
      if (signature != null) {
        print('Signature captured: $signature');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('165'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('completed')
                  .doc(widget.docId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("${'204'.tr}: ${snapshot.error}"));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('206'.tr));
                } else {
                  var documentData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  userUid = documentData['uid'];

                  return documentData['url'] != null
                      ? PDF().cachedFromUrl(documentData['url'])
                      : Center(child: Text('188'.tr));
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(.06),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
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
                      onTap: () {
                        _showSignatureDialog(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.draw_outlined,
                              size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            '172'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
