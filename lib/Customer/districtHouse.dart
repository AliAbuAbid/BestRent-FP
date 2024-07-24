// ignore_for_file: unused_local_variable, unused_field, unused_element

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/Customer/Cities/edit_choices.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/Home.dart';
import 'package:derot/HouseRent/ApartmentIcons.dart';
import 'package:derot/HouseRent/HouseEditor/ShowInfo.dart';
// import 'package:derot/main.dart';
// import 'package:derot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DistrictApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DistrictApp();
  }
}

late DocumentSnapshot selectedPost;

String selectedDistrict = '';
String distLang = '';

class _DistrictApp extends State<DistrictApp> {
  double _ratings = 2.1;
  double avg = 0.1;
  Map<String, dynamic> ratersDict = {};
  bool isLogged = isLoggedIn;
  Kind _selectedhouse = Kind.partners;
  DateTime currentDate = DateTime.now();

  Set<String> favoritePosts = Set();

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
        // Apartment document does not exist
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

  void showContent(String docid) {
    contentId = docid;
    Navigator.of(context).push(CustomPageRoute(
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

      // Update the document with the new data
      await documentRef.update(updatedData);

      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  String translateDist() {
    if (selectedDistrict == 'North') {
      return '117'.tr;
    } else if (selectedDistrict == 'Haifa') {
      return '118'.tr;
    } else if (selectedDistrict == 'Center') {
      return '119'.tr;
    } else if (selectedDistrict == 'TelAviv-Java') {
      return '120'.tr;
    } else if (selectedDistrict == 'South') {
      return '122'.tr;
    } else if (selectedDistrict == 'Jerusalem') {
      return '121'.tr;
    }
    return '';
  }

  void _editChoice() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const EditChoices(),
    );
  }

  // Filters
  String filterPrice = '';
  String filterCity = '';
  String filterHouse = '';
  String filterStreet = '';
  String filterNeighborhood = '';
  String filterRooms = '';

  void _showFilterDialog() {
    setState(() {});
  }

  void _addNotification() async {
    newnot = true;

    String userPhone = '';
    String userFullname = '';
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //User? user = FirebaseAuth.instance.currentUser;
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      QuerySnapshot<Map<String, dynamic>> querySnapshott =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userEmail)
              .get();
      if (querySnapshott.docs.isNotEmpty) {
        userPhone = querySnapshott.docs[0].data()['phone'];
        userFullname = querySnapshott.docs[0].data()['username'];
        //print('User profile photo: $userProfilePhoto');
      } else {
        print('No user found with the email: $userEmail');
      }
      // document = querySnapshott.docs[0].id.toString();

      QuerySnapshot<Map<String, dynamic>> snapshottt =
          await FirebaseFirestore.instance.collection('notifications').get();

      String message = "124".tr;

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

      //documents = snapshot.docs[0].id.toString();
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 50),
            color: Color.fromARGB(69, 196, 191, 191),

            // decoration: BoxDecoration(
            //   color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            //   image: DecorationImage(
            //     image: AssetImage(
            //       'assets/images/houses.jpg',
            //     ),
            //     fit: BoxFit.cover,
            //     colorFilter: ColorFilter.mode(
            //       Colors.black.withOpacity(0.2),
            //       BlendMode.dstATop,
            //     ),
            //   ),
            // ),
            child: Stack(
              children: [
                SizedBox(
                  height: 100,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('apartments')
                      .where('district', isEqualTo: 'States.$distLang')
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
                      //ratersDict = document['raters'];
                      ratersDict.addAll(document['raters']);

                      String orginalString = document['district'];
                      List<String> dist = orginalString.split('.');
                      String districts = dist[1];

                      documentId = document.id;

                      // Filter logic
                      if (filterPrice.isNotEmpty &&
                          document['price'] != filterPrice) return;
                      if (filterCity.isNotEmpty &&
                          document['city'] != filterCity) return;
                      if (filterHouse.isNotEmpty &&
                          document['house'] != filterHouse) return;
                      if (filterStreet.isNotEmpty &&
                          document['street'] != filterStreet) return;
                      if (filterNeighborhood.isNotEmpty &&
                          document['building'] != filterNeighborhood) return;
                      if (filterRooms.isNotEmpty &&
                          document['rooms'] != filterRooms) return;

                      cards.add(
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Container(
                            width: 200, // Set the width as needed
                            height: 390, // Set the height as needed
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
                              borderRadius: BorderRadius.circular(
                                  15), // Adjust the radius for circular corners
                              border: Border.all(
                                color: Colors.black, // Set the border color
                                width: 1, // Set the border width
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
                                                  viewportFraction: 1,
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
                                                  if (isLogged) {
                                                    selectedPost = document;
                                                    toggleFavorite(documentId);
                                                    _addNotification();
                                                  } else {
                                                    final snackBar = SnackBar(
                                                      content: Text(
                                                        '63'.tr,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 49, 48, 48),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors
                                                      .black, // adjust icon color as needed
                                                ),
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
                                        Text('34'.tr + ' ' + city),
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

                                                update_Rating(rating,
                                                    document.id, user!.email);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('112'.tr + ': '),
                                        Text('${document['rating']}'),
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
                    });

                    return ListView(
                      children: cards,
                    );
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              SafeArea(
                child: AppBar(
                  shadowColor: Color.fromARGB(0, 133, 133, 133),
                  backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                  elevation: 0.0,
                  title: Center(
                    child: Text(translateDist()),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return
                                //  title: Text('Filter Apartments'),
                                SingleChildScrollView(
                              child: Container(
                                //height: 1700,
                                padding: EdgeInsets.only(left: 50, right: 50),
                                child: Column(
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration:
                                          InputDecoration(labelText: '30'.tr),
                                      onChanged: (value) {
                                        filterPrice = value;
                                      },
                                    ),
                                    TextField(
                                      decoration:
                                          InputDecoration(labelText: '34'.tr),
                                      onChanged: (value) {
                                        filterCity = value;
                                      },
                                    ),
                                    TextField(
                                      decoration:
                                          InputDecoration(labelText: '35'.tr),
                                      onChanged: (value) {
                                        filterStreet = value;
                                      },
                                    ),
                                    TextField(
                                      decoration:
                                          InputDecoration(labelText: '104'.tr),
                                      onChanged: (value) {
                                        filterNeighborhood = value;
                                      },
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration:
                                          InputDecoration(labelText: '31'.tr),
                                      onChanged: (value) {
                                        filterRooms = value;
                                      },
                                    ),
                                    DropdownButton(
                                        underline: Container(
                                            color: const Color.fromARGB(
                                                0, 255, 255, 255)),
                                        value: _selectedhouse,
                                        items: Kind.values
                                            .map(
                                              (lang) => DropdownMenuItem(
                                                value: lang,
                                                child: Text(
                                                  lang.kindValue.toString(),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value == null) {
                                            return;
                                          }
                                          _selectedhouse = value;
                                          filterHouse = value.toString();
                                          setState(() {});
                                        }),
                                    //  ),

                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          child: Text('36'.tr),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            filterPrice = '';
                                            filterCity = '';
                                            filterHouse = '';
                                            filterStreet = '';
                                            filterNeighborhood = '';
                                            filterRooms = '';
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          child: Text('37'.tr),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
