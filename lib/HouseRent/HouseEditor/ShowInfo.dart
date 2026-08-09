// ignore_for_file: unused_local_variable, unnecessary_import, unused_element, unused_import, deprecated_member_use, duplicate_ignore

import 'package:carousel_slider/carousel_slider.dart';
import 'package:derot/ChattingApp/chat_page.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/HouseRent/HouseEditor/houseEdit.dart';
import 'package:derot/Users/login.dart';
import 'package:derot/drawerFunctions/chats.dart';
import 'package:derot/drawerFunctions/new-apartment.dart';
// import 'package:derot/login1.dart';
import 'package:derot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String contentId = '';
String receiver = '';
String receiverEmail = '';
String receiverusername = '';
String senderName = '';
//String receiverUserID = postUserId;
String postUserIdd = '12';

class _Amenity {
  final String icon;
  final String label;
  final bool active;
  _Amenity(this.icon, this.label, this.active);
}

class ShowInfo extends StatefulWidget {
  @override
  _ShowInfo createState() => _ShowInfo();
}

class _ShowInfo extends State<ShowInfo> {
  User? user = FirebaseAuth.instance.currentUser;
  late String document;
  //String? userEmail = user.toString();
  late String document1;
  String receiverUserEmails = '';
  int k = 0;
  DateTime currentDate = DateTime.now();
  String ali = '';
  String userPhone = '12';

  Set<String> favoritePosts = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (user == null) return;
    final favoritesRef =
        FirebaseFirestore.instance.collection('favourites').doc(user!.email);
    DocumentSnapshot doc = await favoritesRef.get();
    if (doc.exists) {
      setState(() {
        favoritePosts = (doc.data() as Map<String, dynamic>).keys.toSet();
      });
    }
  }

  Future<void> toggleFavorite(String postId) async {
    if (user == null) return;
    final favoritesRef =
        FirebaseFirestore.instance.collection('favourites').doc(user!.email);
    final bool isFav = favoritePosts.contains(postId);

    if (isFav) {
      await favoritesRef.update({postId: FieldValue.delete()});
      setState(() {
        favoritePosts.remove(postId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('127'.tr, style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 49, 48, 48),
        ),
      );
    } else {
      await favoritesRef.set({postId: "documentId"}, SetOptions(merge: true));
      setState(() {
        favoritePosts.add(postId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('124'.tr, style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 49, 48, 48),
        ),
      );
    }
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

  void ViewChat(String postUserId, {String? initialMessage}) {
    Navigator.of(context).push(CustomPageRoute(
      pageBuilder: (context) => ChatPage(
        receiverUserEmail: receiverEmail,
        receiverUserID: postUserIdd,
        receiverUsername: receiverusername,
        initialMessage: initialMessage,
      ),
    ));
  }

  void _addNotification() async {
    String userPhone = '';
    String userFullname = '';
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //User? user = FirebaseAuth.instance.currentUser;
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userEmail)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        userPhone = querySnapshot.docs[0].data()['phone'];
        userFullname = querySnapshot.docs[0].data()['username'];
      } else {
        print('No user found with the email: $userEmail');
      }
      document = querySnapshot.docs[0].id.toString();

      QuerySnapshot<Map<String, dynamic>> snapshott =
          await FirebaseFirestore.instance.collection('notifications').get();

      QuerySnapshot<Map<String, dynamic>> fav =
          await FirebaseFirestore.instance.collection('favourites').get();

      String message = "125";

      print('\nNumber of documents: $k');
      await firestore.collection('notifications').add({
        'email': userEmail,
        'phone': userPhone,
        'msgKey': message,
        'time': DateFormat('HH:mm dd/MM/yyyy').format(currentDate),
        'read': false,
      });

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('notifications')
          .where('email', isEqualTo: userEmail)
          .where('phone', isEqualTo: userPhone)
          .get();

      documents = snapshot.docs[0].id.toString();
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('apartments')
            .doc(contentId) // Fetch document with ID 'ali'
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return SizedBox(
              height: 150,
              child: Center(child: Text('207'.tr)),
            );
          }

          Map<String, dynamic> document = snapshot.data!.data()
              as Map<String, dynamic>; // Extract document data
          userPhone = document['phone'];

          final String originalHouseString =
              (document['house'] ?? '') as String;
          final List<String> houseParts = originalHouseString.split('.');
          final String houseKind =
              houseParts.length > 1 ? houseParts[1] : originalHouseString;

          final List<_Amenity> amenities = [
            _Amenity('assets/icons/pet.svg', '96'.tr, document['Pets'] == true),
            _Amenity('assets/icons/revonated.svg', '93'.tr,
                document['Renovated'] == true),
            _Amenity('assets/icons/shelter.svg', '94'.tr,
                document['Shelter'] == true),
            _Amenity('assets/icons/storage.svg', '95'.tr,
                document['Storage'] == true),
            _Amenity('assets/icons/flexible.svg', '98'.tr,
                document['flexible'] == true),
            _Amenity('assets/icons/access.svg', '92'.tr,
                document['AccessForDisabled'] == true),
            _Amenity('assets/icons/snow.svg', '102'.tr,
                document['AirCondition'] == true),
            _Amenity(
                'assets/icons/bars.svg', '90'.tr, document['Bars'] == true),
            _Amenity('assets/icons/exclusive.svg', '88'.tr,
                document['ExclusiveProperty'] == true),
            _Amenity('assets/icons/furniture.svg', '97'.tr,
                document['Furniture'] == true),
            _Amenity(
                'assets/icons/heater.svg', '91'.tr, document['Heater'] == true),
            _Amenity('assets/icons/longTerm.svg', '99'.tr,
                document['LongTerm'] == true),
          ].where((a) => a.active).toList();

          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          final Color cardColor =
              isDark ? const Color(0xFF1E1E1E) : Colors.white;
          final Color placeholderColor =
              isDark ? Colors.white10 : Colors.grey.shade200;
          final Color primaryText = isDark ? Colors.white : Colors.black;
          final Color mutedText =
              isDark ? Colors.white60 : Colors.grey.shade600;
          final Color descText = isDark ? Colors.white54 : Colors.grey.shade700;
          final bool isOwnListing = document['uid'] != null &&
              document['uid'] == FirebaseAuth.instance.currentUser?.uid;

          return Container(
            width: double.infinity,
            color: cardColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: FutureBuilder<List<String>>(
                          future: _getImages(contentId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 180,
                                color: placeholderColor,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.hasError) {
                              return SizedBox(
                                height: 180,
                                child: Center(
                                    child:
                                        Text("${'204'.tr}: ${snapshot.error}")),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Container(
                                height: 180,
                                width: double.infinity,
                                color: placeholderColor,
                                child: Image.asset('assets/images/NIA.jpg',
                                    fit: BoxFit.contain),
                              );
                            } else {
                              return CarouselSlider.builder(
                                itemCount: snapshot.data!.length,
                                options: CarouselOptions(
                                  height: 180,
                                  autoPlay: false,
                                  enlargeCenterPage: false,
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false,
                                ),
                                itemBuilder:
                                    (BuildContext context, int index, _) {
                                  return GestureDetector(
                                    onTap: () => _showEnlargedImage(
                                        context, snapshot.data![index]),
                                    child: Image.network(
                                      snapshot.data![index],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            houseKind,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 54,
                        child: GestureDetector(
                          onTap: () => toggleFavorite(contentId),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              favoritePosts.contains(contentId)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: favoritePosts.contains(contentId)
                                  ? Colors.redAccent
                                  : (isDark ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close,
                                size: 18,
                                color: isDark ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(.55),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Text(
                            '${document['price'] ?? ''} ₪ / ${'197'.tr}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'17'.tr}: ${document['username'] ?? ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: primaryText),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.redAccent),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${document['street'] ?? ''} ${document['streetNumber'] ?? ''} - ${document['city'] ?? ''}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: primaryText),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${'41'.tr}: ${document['district'] ?? ''}',
                          style: TextStyle(color: mutedText, fontSize: 12.5),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _statChip(Icons.meeting_room_outlined, '31'.tr,
                                '${document['rooms'] ?? ''}'),
                            const SizedBox(width: 8),
                            _statChip(Icons.layers_outlined, '109'.tr,
                                '${document['floar'] ?? ''}'),
                          ],
                        ),
                        if ((document['explain'] ?? '')
                            .toString()
                            .isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            document['explain'],
                            style: TextStyle(color: descText, fontSize: 13),
                          ),
                        ],
                        if (amenities.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                amenities.map((a) => _amenityChip(a)).toList(),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(
                                      color: Color(0xFF0D47A1)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  final phone = userPhone;
                                  if (await canLaunch('tel:$phone')) {
                                    await launch('tel:$phone');
                                  } else {
                                    throw 'Could not launch $phone';
                                  }
                                },
                                child: Text(
                                  '147'.tr,
                                  style: const TextStyle(
                                      color: Color(0xFF0D47A1),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: isOwnListing
                                        ? null
                                        : const LinearGradient(
                                            colors: [
                                              Color(0xFF0D47A1),
                                              Color(0xFF26C6DA)
                                            ],
                                          ),
                                    color: isOwnListing
                                        ? (isDark
                                            ? Colors.white10
                                            : Colors.grey.shade300)
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: isOwnListing
                                          ? null
                                          : () async {
                                              receiver = document['username'];
                                              receiverEmail = document['email'];
                                              receiverusername =
                                                  document['username'];
                                              postUserIdd = document['uid'];
                                              final userEmail = FirebaseAuth
                                                  .instance.currentUser?.email;
                                              QuerySnapshot<
                                                      Map<String, dynamic>>
                                                  querySnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .where('email',
                                                          isEqualTo: userEmail)
                                                      .get();
                                              if (querySnapshot
                                                  .docs.isNotEmpty) {
                                                senderName = querySnapshot
                                                    .docs[0]
                                                    .data()['username'];
                                              } else {
                                                print(
                                                    'No user found with the email: $userEmail');
                                              }
                                              postUserIdd = document['uid'];
                                              final String initialMessage =
                                                  '223'.trParams({
                                                'city':
                                                    '${document['city'] ?? ''}',
                                                'district':
                                                    '${document['district'] ?? ''}',
                                                'street':
                                                    '${document['street'] ?? ''} ${document['streetNumber'] ?? ''}',
                                                'floar':
                                                    '${document['floar'] ?? ''}',
                                                'rooms':
                                                    '${document['rooms'] ?? ''}',
                                                'price':
                                                    '${document['price'] ?? ''}',
                                              });
                                              ViewChat(postUserIdd,
                                                  initialMessage:
                                                      initialMessage);
                                            },
                                      child: Center(
                                        child: Text(
                                          '148'.tr,
                                          style: TextStyle(
                                            color: isOwnListing
                                                ? (isDark
                                                    ? Colors.white38
                                                    : Colors.grey.shade600)
                                                : Colors.white,
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
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statChip(IconData icon, String label, String value) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 15, color: isDark ? Colors.white70 : Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            '$label $value',
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? Colors.white70 : Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amenityChip(_Amenity a) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(isDark ? .22 : .08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(a.icon,
              width: 15, height: 15, color: const Color(0xFF0D47A1)),
          const SizedBox(width: 5),
          Text(
            a.label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF0D47A1),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _getImages(String documentId) async {
    List<String> imageUrls = [];
    Reference imagesRef =
        FirebaseStorage.instance.ref().child('images/$documentId');
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
}
