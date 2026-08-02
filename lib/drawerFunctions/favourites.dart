// ignore_for_file: unused_local_variable, unused_field, unused_import, deprecated_member_use

//import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/Home.dart';
import 'package:derot/HouseRent/HouseEditor/ShowInfo.dart';
// import 'package:derot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:intl/intl.dart';
// import 'package:derot/login11.dart';

class _Amenity {
  final String icon;
  final String label;
  final bool active;
  _Amenity(this.icon, this.label, this.active);
}

class Favourites extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Favourites();
  }
}

late DocumentSnapshot selectedPost;

class _Favourites extends State<Favourites> {
  static const Color _accent = Color(0xFF0D47A1);

  double _ratings = 2.1;
  double avg = 0.1;
  Map<String, dynamic> ratersDict = {};

  Set<String> favoritePosts = Set();
  DateTime currentDate = DateTime.now();
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
        print('');
      }

      QuerySnapshot<Map<String, dynamic>> snapshott =
          await FirebaseFirestore.instance.collection('notifications').get();

      QuerySnapshot<Map<String, dynamic>> fav =
          await FirebaseFirestore.instance.collection('favourites').get();

      String message = "127";

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

  Future<void> deleteFavorite(String postId) async {
    //final postId = selectedPost.id;

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesRef =
          FirebaseFirestore.instance.collection('favourites').doc(user.email);
      await favoritesRef.update({
        postId: FieldValue.delete(),
      });
      setState(() {
        favoritePosts.remove(postId);
        love = false;
      });
      final snackBar = SnackBar(
        content: Text(
          '127'.tr,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 49, 48, 48),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void showContent(String docid) {
    contentId = docid;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.63,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ShowInfo(),
        );
      },
    );
  }

  User? user = FirebaseAuth.instance.currentUser;
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

  late String documentId;
  Future<void> update_Rating(
      double _rating, String documentId, getUserUid) async {
    try {
      CollectionReference apartmentsRef =
          FirebaseFirestore.instance.collection('apartments');

      DocumentReference documentRef = apartmentsRef.doc(documentId);

      ratersDict[getUserUid] = _rating;
      if (!ratersDict.isEmpty) {
        ratersDict.update(getUserUid, (value) => _rating);
      }
      double sum = 0;
      int counter = 0;
      ratersDict.remove('a');
      for (var dict in ratersDict.values) {
        sum += dict;
      }
      counter = ratersDict.length;
      avg = sum / (counter.toDouble());
      Map<String, dynamic> updatedData = {'rating': avg, 'raters': ratersDict};

      await documentRef.update(updatedData);

      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<Set<String>> _getUserFavorites() async {
    Set<String> favoriteIds = {};
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesRef =
          FirebaseFirestore.instance.collection('favourites').doc(user.email);
      DocumentSnapshot docSnapshot = await favoritesRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        favoriteIds = data.keys.toSet();
      }
    }
    return favoriteIds;
  }

  Widget _statChip(IconData icon, String label, String value, bool isDark) {
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

  Widget _amenityChip(_Amenity a, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _accent.withOpacity(isDark ? .22 : .08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(a.icon, width: 15, height: 15, color: _accent),
          const SizedBox(width: 5),
          Text(
            a.label,
            style: TextStyle(
              fontSize: 12,
              color: _accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rentedStatusBadge(String documentId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inProgress')
          .doc(documentId)
          .snapshots(),
      builder: (context, inProgressSnap) {
        final bool isInProgress = inProgressSnap.data?.exists ?? false;
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('completed')
              .doc(documentId)
              .snapshots(),
          builder: (context, completedSnap) {
            final bool isCompleted = completedSnap.data?.exists ?? false;
            if (!isInProgress && !isCompleted) {
              return const SizedBox.shrink();
            }
            return Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.shade600
                    : Colors.deepOrange.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isCompleted ? '152'.tr : '151'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHouseCard(BuildContext context, QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String docId = doc.id;

    final String houseRaw = (data['house'] ?? '').toString();
    final String houseKind =
        houseRaw.contains('.') ? houseRaw.split('.')[1] : houseRaw;

    final String districtRaw = (data['district'] ?? '').toString();
    final String districts =
        districtRaw.contains('.') ? districtRaw.split('.')[1] : districtRaw;

    ratersDict.addAll((data['raters'] as Map?)?.cast<String, dynamic>() ?? {});

    final amenities = <_Amenity>[
      _Amenity('assets/icons/pet.svg', '96'.tr, data['Pets'] == true),
      _Amenity(
          'assets/icons/revonated.svg', '93'.tr, data['Renovated'] == true),
      _Amenity('assets/icons/shelter.svg', '94'.tr, data['Shelter'] == true),
      _Amenity('assets/icons/storage.svg', '95'.tr, data['Storage'] == true),
      _Amenity('assets/icons/flexible.svg', '98'.tr, data['flexible'] == true),
      _Amenity('assets/icons/access.svg', '92'.tr,
          data['AccessForDisabled'] == true),
      _Amenity('assets/icons/snow.svg', '102'.tr, data['AirCondition'] == true),
      _Amenity('assets/icons/bars.svg', '90'.tr, data['Bars'] == true),
      _Amenity('assets/icons/exclusive.svg', '88'.tr,
          data['ExclusiveProperty'] == true),
      _Amenity(
          'assets/icons/furniture.svg', '97'.tr, data['Furniture'] == true),
      _Amenity('assets/icons/heater.svg', '91'.tr, data['Heater'] == true),
      _Amenity('assets/icons/longTerm.svg', '99'.tr, data['LongTerm'] == true),
    ].where((a) => a.active).toList();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color placeholderColor =
        isDark ? Colors.white10 : Colors.grey.shade200;
    final Color primaryText = isDark ? Colors.white : Colors.black;
    final Color mutedText = isDark ? Colors.white60 : Colors.grey.shade600;
    final Color mutedText2 = isDark ? Colors.white38 : Colors.grey.shade500;
    final Color descText = isDark ? Colors.white54 : Colors.grey.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
      ),
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
                  future: _getImages(docId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 180,
                        color: placeholderColor,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                        itemBuilder: (BuildContext context, int index, _) {
                          return Image.network(
                            snapshot.data![index],
                            width: double.infinity,
                            fit: BoxFit.cover,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                    _rentedStatusBadge(docId),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    _addNotification();
                    deleteFavorite(docId);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite,
                        size: 18, color: Colors.redAccent),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                    '${data['price'] ?? ''} ₪ / ${'197'.tr}',
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
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${data['street'] ?? ''} ${data['streetNumber'] ?? ''} - ${data['city'] ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: primaryText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${'41'.tr}: $districts',
                  style: TextStyle(color: mutedText, fontSize: 12.5),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if ((data['rooms'] ?? '').toString().isNotEmpty)
                      _statChip(Icons.meeting_room_outlined, '31'.tr,
                          '${data['rooms'] ?? ''}', isDark),
                    if ((data['rooms'] ?? '').toString().isNotEmpty)
                      const SizedBox(width: 8),
                    if ((data['floar'] ?? '').toString().isNotEmpty)
                      _statChip(Icons.layers_outlined, '109'.tr,
                          '${data['floar'] ?? ''}', isDark),
                  ],
                ),
                if ((data['explain'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    data['explain'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: descText, fontSize: 13),
                  ),
                ],
                if (amenities.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        amenities.map((a) => _amenityChip(a, isDark)).toList(),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: (data['rating'] as num?)?.toDouble() ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 16,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _ratings = rating;
                          update_Rating(rating, docId, user!.email);
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${data['rating'] ?? ''}',
                      style: TextStyle(color: mutedText, fontSize: 12.5),
                    ),
                    const Spacer(),
                    Text(
                      '${data['postedDate'] ?? ''}',
                      style: TextStyle(color: mutedText2, fontSize: 11.5),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 42,
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
                        onTap: () => showContent(docId),
                        child: Center(
                          child: Text(
                            '129'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text('62'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<Set<String>>(
          future: _getUserFavorites(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            Set<String> favoriteIds = snapshot.data!;

            if (favoriteIds.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 48,
                        color: isDark ? Colors.white24 : Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      '128'.tr,
                      style: TextStyle(
                          color:
                              isDark ? Colors.white70 : Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('apartments')
                  .where(FieldPath.documentId, whereIn: favoriteIds.toList())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      '128'.tr,
                      style: TextStyle(
                          color:
                              isDark ? Colors.white70 : Colors.grey.shade600),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) =>
                      _buildHouseCard(context, docs[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
