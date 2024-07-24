// ignore_for_file: unused_local_variable, unnecessary_import, unused_element

import 'package:carousel_slider/carousel_slider.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/HouseRent/HouseEditor/houseEdit.dart';
import 'package:derot/HouseRent/HouseEditor/myHouses.dart';
import 'package:derot/HouseRent/InProgress/inProgress.dart';
import 'package:derot/HouseRent/InProgress/showCoContrant.dart';
// import 'package:derot/login1.dart';
import 'package:derot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Completed extends StatefulWidget {
  @override
  _MyHouse createState() => _MyHouse();
}

class _MyHouse extends State<Completed> {
  User? user = FirebaseAuth.instance.currentUser;
  late String document;
  //String? userEmail = user.toString();
  late String document1;
  String? usernamee;
  int k = 0;
  DateTime currentDate = DateTime.now();
  String ali = '';
  TextEditingController _nameController1 = TextEditingController();
  TextEditingController _nameController2 = TextEditingController();
  TextEditingController _nameController3 = TextEditingController();
  TextEditingController _nameController4 = TextEditingController();
  TextEditingController _nameController5 = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Widget textField(TextEditingController name, String label) {
    return Container(
      width: 250,
      //  width: 150,
      //textDirection: TextDirection.rtl,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
        height: 50,
        // color: Colors.white,
        child: TextFormField(
          controller: name,
          textAlign: TextAlign.left, // Align the label text to the right

          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(), // Default border sides
              ),
              labelText: label,
              labelStyle: TextStyle(color: Colors.black)),

          //validator: validatorForm,
        ),
      ),
    );
  }

  Future<void> moveDocument(String apartmentId) async {
    try {
      // Get the document from the "apartments" collection
      DocumentSnapshot apartmentDoc =
          await _firestore.collection('apartments').doc(apartmentId).get();

      if (apartmentDoc.exists) {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  height: 500,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          textField(_nameController1, '154'.tr),
                          textField(_nameController2, '155'.tr),
                          textField(_nameController3, '156'.tr),
                          textField(_nameController4, '157'.tr),
                          textField(_nameController5, '158'.tr),
                          TextButton(
                            onPressed: () async {
                              if (_nameController1.text.isEmpty &&
                                  _nameController2.text.isEmpty &&
                                  _nameController3.text.isEmpty &&
                                  _nameController4.text.isEmpty &&
                                  _nameController5.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('159'.tr)),
                                );
                                return;
                              } else {
                                try {
                                  DocumentSnapshot apartmentDoc =
                                      await _firestore
                                          .collection('apartments')
                                          .doc(apartmentId)
                                          .get();
                                  String usernameA = apartmentDoc['username'];
                                  if (apartmentDoc.exists) {
                                    // Get the data from the document
                                    Map<String, dynamic> apartmentData =
                                        apartmentDoc.data()
                                            as Map<String, dynamic>;

                                    // Add the additional fields
                                    apartmentData['name1'] =
                                        _nameController1.text;

                                    apartmentData['name2'] =
                                        _nameController2.text;
                                    apartmentData['name3'] =
                                        _nameController3.text;
                                    apartmentData['name4'] =
                                        _nameController4.text;
                                    apartmentData['name5'] =
                                        _nameController5.text;
                                    apartmentData['$usernameA'] = false;
                                    apartmentData[
                                        _nameController1.text.isNotEmpty
                                            ? '${_nameController1.text}'
                                            : 'name11'] = false;
                                    apartmentData[
                                        _nameController2.text.isNotEmpty
                                            ? '${_nameController2.text}'
                                            : 'name22'] = false;
                                    apartmentData[
                                        _nameController3.text.isNotEmpty
                                            ? '${_nameController3.text}'
                                            : 'name33'] = false;
                                    apartmentData[
                                        _nameController4.text.isNotEmpty
                                            ? '${_nameController4.text}'
                                            : 'name44'] = false;
                                    apartmentData[
                                        _nameController5.text.isNotEmpty
                                            ? '${_nameController5.text}'
                                            : 'name55'] = false;
                                    apartmentData['hhhhhhh'] = true;

                                    // Add the data to the "inProgress" collection
                                    await _firestore
                                        .collection('inProgress')
                                        .doc(apartmentId)
                                        .set(apartmentData);

                                    // Optionally, you can delete the document from the "apartments" collection
                                    // await _firestore.collection('apartments').doc(apartmentId).delete();
                                  } else {
                                    print(
                                        'Document does not exist in the "apartments" collection.');
                                  }
                                } catch (e) {
                                  print('Error moving document: $e');
                                }
                                Navigator.of(context).pushReplacement(
                                    CustomPageRoute(
                                        pageBuilder: (context) =>
                                            InProgress()));
                              }
                            },
                            child: Text('153'.tr),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });

        // Optionally, you can delete the document from the "apartments" collection
        // await _firestore.collection('apartments').doc(apartmentId).delete();
      } else {
        print('Document does not exist in the "apartments" collection.');
      }
    } catch (e) {
      print('Error moving document: $e');
    }
  }

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
        print('No user found with the email: $userEmail');
      }
      document = querySnapshot.docs[0].id.toString();

      QuerySnapshot<Map<String, dynamic>> snapshott =
          await FirebaseFirestore.instance.collection('notifications').get();

      String message = "125".tr;

      print('\nNumber of documents: $k');
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
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Images from Firebase Storage'),
      // ),
      body: Container(
        color: Color.fromARGB(21, 0, 0, 1),
        child: Stack(
          children: [
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('completed')
                  .where('email', isEqualTo: user!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // return Center(child: CircularProgressIndicator());
                  return Center(
                    child: Text('Current user email: ${user!.email}'),
                  );
                }

                List<Widget> cards = [];

                snapshot.data!.docs.forEach((document) {
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

                  String documentId = document.id;
                  String originalString = document['house'];
                  List<String> parts = originalString.split('.');
                  String houseKind = parts[1];

                  String orginalString = document['district'];
                  List<String> dist = orginalString.split('.');
                  String districts = dist[1];

                  //String documentss = documents;
                  cards.add(
                    Card(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 60,
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          CustomPageRoute(
                                                              pageBuilder:
                                                                  (context) =>
                                                                      ShowOwnContract(
                                                                        docId:
                                                                            documentId,
                                                                      )));
                                                },
                                                child: Text('162'.tr)),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              icon: Icon(Icons.more_vert),
                            ),
                          ),
                          Text('17'.tr + ': ' + document['username']),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('73'.tr + ': ' + document['phone']),
                          SizedBox(
                            height: 10,
                          ),
                          Text('18'.tr + ': ' + document['email']),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('35'.tr + ': ' + document['street']),
                              SizedBox(width: 10),
                              Text(' | '),
                              SizedBox(width: 10),
                              Text('42'.tr + ': ' + document['streetNumber']),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('34'.tr + ' ' + document['city']),
                              SizedBox(width: 10),
                              Text(' | '),
                              SizedBox(width: 10),
                              Text('50'.tr + ': ' + houseKind),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('41'.tr + ': ' + districts),
                          //////////////////////
                          ///fdfdfd

                          ////////////////////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('104'.tr + ': ' + document['building']),
                              SizedBox(width: 10),
                              Text(' | '),
                              SizedBox(width: 10),
                              Text('31'.tr + ' ' + document['rooms']),
                              SizedBox(width: 10),
                              SizedBox(width: 10),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('109'.tr + ' ' + document['floar']),
                              SizedBox(width: 10),
                              Text(' | '),
                              SizedBox(width: 10),
                              Text('30'.tr + ' ' + document['price']),
                              SizedBox(height: 10),
                            ],
                          ),

                          Text('39'.tr + ': ' + document['explain']),
                          SizedBox(
                            height: 10,
                          ),

                          FutureBuilder<List<String>>(
                            future: _getImages(documentId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(child: Text('No images found'));
                              } else {
                                return CarouselSlider.builder(
                                  itemCount: snapshot.data!.length,
                                  options: CarouselOptions(
                                    height: 150.0,
                                    autoPlay: false,
                                    enlargeCenterPage: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 0.8,
                                    onPageChanged: (index, reason) {
                                      // Handle page change
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index, _) {
                                    return GestureDetector(
                                      onTap: () {
                                        _showEnlargedImage(
                                            context, snapshot.data![index]);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Image.network(
                                          snapshot.data![index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: document['Pets']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/pet.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '96'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/pet.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '96'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              /////////////////////////////////
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: document['Renovated']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/revonated.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '93'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/revonated.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '93'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),

                              /////////////////////////////////
                              Expanded(
                                flex: -2,
                                child: document['Shelter']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/shelter.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '94'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/shelter.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '94'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          /////////////////////////////////
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: document['Storage']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/storage.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '95'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/storage.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '95'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              /////////////////////////////////
                              Expanded(
                                child: document['flexible']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/flexible.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '98'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/flexible.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '98'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),

                              /////////////////////////////////
                              Expanded(
                                flex: -2,
                                child: document['AccessForDisabled']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/access.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '92'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/access.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '92'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          /////////////////////////////////
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: document['AirCondition']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/snow.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '102'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/snow.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '102'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              /////////////////////////////////
                              Expanded(
                                flex: 2,
                                child: document['Bars']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/bars.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '90'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/bars.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '90'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              /////////////////////////////////
                              // SizedBox(
                              //   width: 20,
                              // ),
                              Expanded(
                                flex: -2,
                                child: document['ExclusiveProperty']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/exclusive.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '88'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/exclusive.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '88'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(height: 10),
                          /////////////////////////////////
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: document['Furniture']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/furniture.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '97'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/furniture.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '97'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              /////////////////////////////////
                              Expanded(
                                child: document['Heater']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/heater.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '91'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/heater.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '91'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),

                              /////////////////////////////////
                              Expanded(
                                flex: -2,
                                child: document['LongTerm']
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/longTerm.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '99'.tr,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/longTerm.svg',
                                            // Path to your SVG file
                                            width:
                                                18, // Adjust the width as needed
                                            height:
                                                18, // Adjust the height as needed
                                            // ignore: deprecated_member_use
                                            color: Color.fromARGB(255, 191, 180,
                                                180), // Set the color of the icon
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '99'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 191, 180, 180),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),

                          /////////////////////////////////
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                });

                return ListView(
                  padding: EdgeInsets.only(top: 120, left: 5, right: 5),
                  children: cards,
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
                // SizedBox(
                //   height: 50,
                // ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(CustomPageRoute(
                            pageBuilder: (context) => MyHouse()));
                      },
                      child: Center(
                        child: Text('150'.tr),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('|'),
                    SizedBox(
                      width: 5,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(CustomPageRoute(
                              pageBuilder: (context) => InProgress()));
                        },
                        child: Text('151'.tr)),
                    SizedBox(
                      width: 5,
                    ),
                    Text('|'),
                    SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        height: 30,
                        width: 90,
                        //  color: Colors.white,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Border color
                            width: 1.0, // Border width
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0), // Radius value
                          ),
                        ),
                        child: Center(
                          child: Text('152'.tr),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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

  Future<void> deleteFolder(String folderPath) async {
    Reference folderRef = FirebaseStorage.instance.ref().child(folderPath);

    try {
      // List all items (files and subdirectories) in the folder
      ListResult listResult = await folderRef.listAll();

      // Delete each item (file or subdirectory)
      for (Reference ref in listResult.items) {
        // If the item is a subdirectory, recursively delete its contents
        if (ref.fullPath.endsWith('/')) {
          await deleteFolder(ref.fullPath);
        } else {
          // If the item is a file, delete it
          await ref.delete();
        }
      }

      // After deleting all contents, delete the folder itself
      await folderRef.delete();
      print('Folder deleted successfully: $folderPath');
    } catch (e) {
      print('Error deleting folder: $e');
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

  void editHouse() {
    Navigator.of(context).pushReplacement(CustomPageRoute(
      pageBuilder: (context) => EditHouse(
        documentId: ali,
      ),
    ));
  }
}
