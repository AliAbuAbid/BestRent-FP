// ignore_for_file: unused_local_variable, unused_field, unused_element

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

  void showContent(String docid) {
    contentId = docid;
    Navigator.of(context).push(CustomPageRoute(
      pageBuilder: (context) => ShowInfo(),
    ));
  }

  Future<void> toggleFavorite(String postId) async {
    User? user = FirebaseAuth.instance.currentUser;
    final postId = selectedPost.id;
    if (user != null) {
      final favoritesRef =
          FirebaseFirestore.instance.collection('favourites').doc(user.email);

      // Check if the document exists in the apartments collection
      DocumentSnapshot apartmentSnapshot = await FirebaseFirestore.instance
          .collection('apartments')
          .doc(postId)
          .get();

      if (apartmentSnapshot.exists) {
        // Check if the document already exists in the favourites collection
        DocumentSnapshot favouritesSnapshot = await favoritesRef.get();
        if (favouritesSnapshot.exists &&
            (favouritesSnapshot.data() as Map<String, dynamic>)
                .containsKey(postId)) {
          // Document already exists in favourites, show a message
          final snackBar = SnackBar(
            content: Text(
              '114'.tr,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          // Add to favourites
          await favoritesRef
              .set({postId: "documentId"}, SetOptions(merge: true));
          setState(() {
            favoritePosts.add(postId);
            love = true;
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
      } else {
        final snackBar = SnackBar(
          content: Text(
            'Apartment not found',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
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
                for (var dict in cityRatings.entries) {
                  if (document['city'] == dict.key &&
                      document['rating'] == dict.value) {
                    cards.add(
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: Container(
                          width: 200,
                          height: 365,
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
                            borderRadius: BorderRadius.circular(5),
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
                                            child: CircularProgressIndicator());
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
                                              itemCount: snapshot.data!.length,
                                              options: CarouselOptions(
                                                height: 200.0,
                                                autoPlay: false,
                                                enlargeCenterPage: true,
                                                aspectRatio: 16 / 9,
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                enableInfiniteScroll: false,
                                                viewportFraction: 1.0,
                                                onPageChanged:
                                                    (index, reason) {},
                                                scrollDirection:
                                                    Axis.horizontal,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index, _) {
                                                return Container(
                                                  width: 1000,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ),
                                                  child: Image.network(
                                                    width: double.infinity,
                                                    snapshot.data![index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (isLogged) {
                                                  selectedPost = document;
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
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors
                                                    .black, // adjust icon color as needed
                                              ),
                                              //  ),
                                              //),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('34'.tr + ' ' + document['city']),
                                      SizedBox(width: 10),
                                      Text('41'.tr + ': ' + districts),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('30'.tr + ': ' + document['price']),
                                      SizedBox(width: 10),
                                      Text('42'.tr +
                                          ': ' +
                                          document['street'] +
                                          ' ' +
                                          document['streetNumber']),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          ''.tr + ' ' + document['postedDate']),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('112'.tr + ': '),
                                      Text(
                                        '${document['rating'] == 0.1 ? document['rating'] - 0.1 : document['rating']}',
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
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
                                            if (isLoggedIn) {
                                              _ratings = rating;

                                              update_Rating(rating, document.id,
                                                  user!.email);
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
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          if (isLogged == true) {
                                            showContent(document.id);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('63'.tr),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text('129'.tr),
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
