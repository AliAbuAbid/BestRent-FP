// ignore_for_file: unused_local_variable, unused_field, unused_element, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/Home.dart';
import 'package:derot/HouseRent/HouseEditor/ShowInfo.dart';
// import 'package:derot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BestOffers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BestOffers();
  }
}

late DocumentSnapshot selectedPost;

class _BestOffers extends State<BestOffers> {
  double _ratings = 2.1;
  double avg = 0.1;
  Map<String, dynamic> ratersDict = {};
  bool isLogged = isLoggedIn;

  Set<String> favoritePosts = Set();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final favoritesRef =
        FirebaseFirestore.instance.collection('favourites').doc(user.email);
    DocumentSnapshot doc = await favoritesRef.get();
    if (doc.exists) {
      setState(() {
        favoritePosts = (doc.data() as Map<String, dynamic>).keys.toSet();
      });
    }
  }

  void showContent(String docid) {
    contentId = docid;

    // Navigator.of(context).push(CustomPageRoute(
    //   pageBuilder: (context) => ShowInfo(),
    // ));
  }

  Future<void> toggleFavorite(String postId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final favoritesRef =
        FirebaseFirestore.instance.collection('favourites').doc(user.email);
    final bool isFav = favoritePosts.contains(postId);

    if (isFav) {
      await favoritesRef.update({postId: FieldValue.delete()});
      setState(() {
        favoritePosts.remove(postId);
      });
      final snackBar = SnackBar(
        content: Text(
          '127'.tr,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 49, 48, 48),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await favoritesRef.set({postId: "documentId"}, SetOptions(merge: true));
      setState(() {
        favoritePosts.add(postId);
      });
      final snackBar = SnackBar(
        content: Text(
          '124'.tr,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 49, 48, 48),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                isCompleted ? '152'.tr : '151'.tr,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> update_Rating(
      double _rating, String documentId, getUserUid) async {
    try {
      CollectionReference apartmentsRef =
          FirebaseFirestore.instance.collection('apartments');

      DocumentReference documentRef = apartmentsRef.doc(documentId);

      ratersDict[getUserUid] = _rating;
      if (!ratersDict.isEmpty) {
        ratersDict.update(getUserUid, (value) => _rating);
        //ratersDict.update(key, (value) => null)
      }
      double sum = 0;
      int counter = 0;
      ratersDict.remove('a');
      for (var dict in ratersDict.values) {
        sum += dict;
      }
      //sum = sum - 0.1;
      counter = ratersDict.length;
      avg = sum / (counter.toDouble());
      Map<String, dynamic> updatedData = {'rating': avg, 'raters': ratersDict};

      await documentRef.update(updatedData);

      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color placeholderColor =
        isDark ? Colors.white10 : Colors.grey.shade200;
    final Color primaryText = isDark ? Colors.white : Colors.black87;
    final Color mutedText = isDark ? Colors.white60 : Colors.grey.shade600;
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('apartments').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {}

              List<Widget> cards = [];

              snapshot.data?.docs.forEach((document) {
                String address = document['email'];
                String city = document['city'];
                bool pets = document['Pets'];
                bool renovated = document['Renovated'];
                bool shelter = document['Shelter'];
                String building = document['building'];
                String district = document['district'];
                String explain = document['explain'];
                bool storage = document['Storage'];
                bool accessForDisabled = document['AccessForDisabled'];
                bool airCondition = document['AirCondition'];
                bool bars = document['Bars'];
                bool exclusiveProperty = document['LongTerm'];
                bool furniture = document['Furniture'];
                bool heater = document['Heater'];
                bool longTerm = document['LongTerm'];
                String house = document['house'];
                String phone = document['phone'];
                String price = document['price'];
                String street = document['street'];
                String floar = document['floar'];
                String streetNumber = document['streetNumber'];
                String username = document['username'];
                bool flexible = document['flexible'];
                String postedDate = document['postedDate'];

                ratersDict.addAll(document['raters']);

                String orginalString = document['district'];
                List<String> dist = orginalString.split('.');
                String districts = dist[1];

                String originalHouseString = document['house'];
                List<String> parts = originalHouseString.split('.');
                String houseKind = parts[1];

                final String documentId = document.id;
                Map<String, double> cityRatings = {};
                snapshot.data?.docs.forEach((document) {
                  String city = document['city'];
                  double rating = document['rating'];

                  if (cityRatings.containsKey(city)) {
                    if (rating > cityRatings[city]!) {
                      cityRatings[city] = rating;
                    }
                  } else {
                    cityRatings[city] = rating;
                  }
                });
                for (var dict in cityRatings.entries) {
                  if (document['city'] == dict.key &&
                      document['rating'] == dict.value) {
                    final bool isFav = favoritePosts.contains(documentId);
                    void openDetails() {
                      if (isLogged == true) {
                        showContent(document.id);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.63,
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: ShowInfo(),
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('63'.tr)),
                        );
                      }
                    }

                    cards.add(
                      Padding(
                        padding: EdgeInsets.only(bottom: 16, top: 4),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.08),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                                child: SizedBox(
                                  height: 190,
                                  child: FutureBuilder<List<String>>(
                                    future: _getImages(documentId),
                                    builder: (context, snapshot) {
                                      Widget imageArea;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        imageArea = const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        imageArea = Center(
                                            child: Text(
                                                "${'204'.tr}: ${snapshot.error}"));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        imageArea = Container(
                                          width: double.infinity,
                                          color: placeholderColor,
                                          child: Image.asset(
                                            'assets/images/NIA.jpg',
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      } else {
                                        imageArea = CarouselSlider.builder(
                                          itemCount: snapshot.data!.length,
                                          options: CarouselOptions(
                                            height: 190.0,
                                            autoPlay: false,
                                            enlargeCenterPage: false,
                                            aspectRatio: 16 / 9,
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enableInfiniteScroll: false,
                                            viewportFraction: 1.0,
                                            onPageChanged: (index, reason) {},
                                            scrollDirection: Axis.horizontal,
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index, _) {
                                            return Image.network(
                                              snapshot.data![index],
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        );
                                      }
                                      return Stack(
                                        children: [
                                          Positioned.fill(child: imageArea),

                                          /// ⭐ Featured badge
                                          Positioned(
                                            top: 12,
                                            left: 12,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFFC107),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999),
                                                  ),
                                                  child: Text(
                                                    '196'.tr,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                _rentedStatusBadge(documentId),
                                              ],
                                            ),
                                          ),

                                          /// ♥ Favorite button
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              onTap: () {
                                                if (isLogged) {
                                                  toggleFavorite(documentId);
                                                } else {
                                                  final snackBar = SnackBar(
                                                    content: Text(
                                                      '63'.tr,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 49, 48, 48),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              },
                                              child: Container(
                                                width: 34,
                                                height: 34,
                                                decoration: BoxDecoration(
                                                  color: cardColor,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(.15),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  isFav
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isFav
                                                      ? Colors.red
                                                      : primaryText,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),

                                          /// 💰 Price overlay
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      14, 22, 14, 10),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                        .withOpacity(.65),
                                                  ],
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    '${document['price']} ₪',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '197'.tr,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(.85),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 12, 14, 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      houseKind,
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: primaryText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 15,
                                            color: Colors.red.shade300),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            '${document['city']} - $districts',
                                            style: GoogleFonts.lato(
                                              fontSize: 12.5,
                                              color: mutedText,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                size: 17,
                                                color: Color(0xFFFFC107)),
                                            const SizedBox(width: 3),
                                            Text(
                                              '${document['rating'] == 0.1 ? document['rating'] - 0.1 : document['rating']}',
                                              style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: primaryText,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '(${ratersDict.length} ${'198'.tr})',
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: mutedText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.stairs_outlined,
                                                size: 16, color: mutedText),
                                            const SizedBox(width: 3),
                                            Text(
                                              document['floar'],
                                              style: GoogleFonts.lato(
                                                fontSize: 12.5,
                                                color: mutedText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF0D47A1),
                                              Color(0xFF26C6DA),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            onTap: openDetails,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '129'.tr,
                                                  style: GoogleFonts.lato(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                const Icon(
                                                    Icons.arrow_back_rounded,
                                                    color: Colors.white,
                                                    size: 18),
                                              ],
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
                        ),
                      ),
                    );
                  }
                }
              });

              return ListView(
                children: cards,
              );
            },
          ),
        ],
      ),
    );
  }
}
