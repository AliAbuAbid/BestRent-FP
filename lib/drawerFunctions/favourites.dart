// ignore_for_file: unused_local_variable, unused_field, unused_import

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
import 'package:get/get.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:intl/intl.dart';
// import 'package:derot/login11.dart';

class Favourites extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Favourites();
  }
}

late DocumentSnapshot selectedPost;

class _Favourites extends State<Favourites> {
  double _ratings = 2.1;
  double avg = 0.1;
  Map<String, dynamic> ratersDict = {};

  Set<String> favoritePosts = Set();
  DateTime currentDate = DateTime.now();
  void _addNotification() async {
    setState(() {
      newnot = true;
    });
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

      String message = "127".tr;

      await firestore.collection('notifications').add({
        'email': userEmail,
        'phone': userPhone,
        'msg': message,
        'time': DateFormat('HH:mm dd/MM/yyyy').format(currentDate),
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
    Navigator.of(context).pushReplacement(CustomPageRoute(
      pageBuilder: (context) => ShowInfo(),
    ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        color: Color.fromARGB(21, 0, 0, 1),

      
        child: Stack(
          children: [
            FutureBuilder<Set<String>>(
              future: _getUserFavorites(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                Set<String> favoriteIds = snapshot.data!;

                if (favoriteIds.isEmpty) {
                  return Center(
                    child: Text(
                      '128'.tr,
                      style:
                          TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                  );
                }
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('apartments')
                      .where(FieldPath.documentId,
                          whereIn: favoriteIds.toList())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

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

                      documentId = document.id;
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

                      cards.add(
                        Padding(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          child: Container(
                            width: 200,
                            height: 350,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 230, 231, 238),
                                  Color.fromARGB(255, 231, 230, 236),
                                  Color.fromARGB(255, 216, 216, 219),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FutureBuilder<List<String>>(
                                      future: _getImages(documentId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                              child: Text('No images found'));
                                        } else {
                                          return Stack(
                                            children: [
                                              CarouselSlider.builder(
                                                itemCount:
                                                    snapshot.data!.length,
                                                options: CarouselOptions(
                                                  height: 200.0,
                                                  autoPlay: false,
                                                  enlargeCenterPage: true,
                                                  aspectRatio: 16 / 9,
                                                  autoPlayCurve:
                                                      Curves.fastOutSlowIn,
                                                  enableInfiniteScroll: false,
                                                  viewportFraction: 0.8,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    // Handle page change
                                                  },
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                ),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index, _) {
                                                  return Container(
                                                    width: 900,
                                                    // width: MediaQuery.of(context)
                                                    //     .size
                                                    //     .width,
                                                    // margin: EdgeInsets.symmetric(
                                                    //     horizontal: 5.0),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                    ),
                                                    child: Image.network(
                                                      snapshot.data![index],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    _addNotification();
                                                    deleteFavorite(document.id);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ) //Container(
                                                  //   width:
                                                  //       25, // adjust width as needed
                                                  //   height:
                                                  //       25, // adjust height as needed
                                                  //   decoration: BoxDecoration(
                                                  //     shape: BoxShape.circle,
                                                  //     color: Colors.white,
                                                  //   ),
                                                  //   child: Center(
                                                  //     child: Icon(
                                                  //       Icons.delete,
                                                  //       color: const Color
                                                  //           .fromARGB(255, 255, 0,
                                                  //           0), // adjust icon color as needed
                                                  //     ),
                                                  //   ),

                                                  ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('34'.tr + ' ' + document['city']),
                                        SizedBox(width: 10),
                                        Text('41'.tr + ': ' + districts),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            '30'.tr + ': ' + document['price']),
                                        SizedBox(width: 10),
                                        Text('42'.tr +
                                            ': ' +
                                            document['street'] +
                                            ' ' +
                                            document['streetNumber']),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(''.tr +
                                            ' ' +
                                            document['postedDate']),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 10),
                                            Text('112'.tr + ': '),
                                            Text('${document['rating']}'),
                                            SizedBox(width: 20),
                                            RatingBar.builder(
                                              initialRating: document['rating'],
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              onRatingUpdate: (rating) {
                                                setState(() {
                                                  _ratings = rating;

                                                  update_Rating(rating,
                                                      document.id, user!.email);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                showContent(document.id);
                                              },
                                              child: Text('129'.tr),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });

                    return ListView(
                      padding: EdgeInsets.only(top: 65),
                      children: cards,
                    );
                  },
                );
              },
            ),
            Column(
              children: [
                SafeArea(
                  child: AppBar(
                    shadowColor: Color.fromARGB(0, 133, 133, 133),
                    backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                    elevation: 0.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
