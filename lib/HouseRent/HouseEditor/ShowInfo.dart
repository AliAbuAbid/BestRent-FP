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

  void ViewChat(String postUserId) {
    Navigator.of(context).push(CustomPageRoute(
      pageBuilder: (context) => ChatPage(
        receiverUserEmail: receiverEmail,
        receiverUserID: postUserIdd,
        receiverUsername: receiverusername,
      ),
    ));
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

      QuerySnapshot<Map<String, dynamic>> fav =
          await FirebaseFirestore.instance.collection('favourites').get();

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
      body: Container(
        color: Color.fromARGB(255, 172, 169, 169),
        child: Stack(
          children: [
            SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('apartments')
                  .doc(contentId) // Fetch document with ID 'ali'
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('Document not found'));
                }

                Map<String, dynamic> document = snapshot.data!.data()
                    as Map<String, dynamic>; // Extract document data
                userPhone = document['phone'];

                return ListView(
                  padding:
                      EdgeInsets.only(top: 75, left: 10, right: 10, bottom: 10),
                  children: [
                    Container(
                      // padding: EdgeInsets.all(10),
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
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<List<String>>(
                            future: _getImages(contentId),
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
                          SizedBox(height: 10),
                          Text('17'.tr + ': ${document['username']}'),
                          SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('35'.tr + ': ${document['street']}'),
                              SizedBox(width: 10),
                              Text(' | '),
                              SizedBox(width: 10),
                              Text('42'.tr + ': ${document['streetNumber']}'),
                              SizedBox(width: 10),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('34'.tr + ': ${document['city']}'),
                              SizedBox(width: 10),
                              Text(' | '),
                              SizedBox(width: 10),
                              Text('50'.tr +
                                  ': ${document['house'].split('.')[1]}'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text('41'.tr + ': ${document['district']}'),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('104'.tr + ': ${document['building']}'),
                              SizedBox(width: 10),
                              Text(' | '),
                              SizedBox(width: 10),
                              Text('31'.tr + ': ${document['rooms']}'),
                              SizedBox(width: 10),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('109'.tr + ': ${document['floar']}'),
                              SizedBox(width: 10),
                              Text(' | '),
                              SizedBox(width: 10),
                              Text('30'.tr + ': ${document['price']}'),
                              SizedBox(height: 10),
                            ],
                          ),
                          Text('39'.tr + ': ${document['explain']}'),
                          SizedBox(height: 10),

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

                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final phone = userPhone;
                                  //const phone = phoneHH;
                                  if (await canLaunch('tel:$phone')) {
                                    await launch('tel:$phone');
                                  } else {
                                    throw 'Could not launch $phone';
                                  }
                                },
                                child: Text('147'.tr),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  receiver = document['username'];
                                  receiverEmail = document['email'];
                                  receiverusername = document['username'];
                                  postUserIdd = document['uid'];
                                  FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;
                                  //User? user = FirebaseAuth.instance.currentUser;
                                  final userEmail =
                                      FirebaseAuth.instance.currentUser?.email;
                                  QuerySnapshot<Map<String, dynamic>>
                                      querySnapshot = await FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .where('email', isEqualTo: userEmail)
                                          .get();
                                  if (querySnapshot.docs.isNotEmpty) {
                                    senderName = querySnapshot.docs[0]
                                        .data()['username'];
                                    //print('User profile photo: $userProfilePhoto');
                                  } else {
                                    print(
                                        'No user found with the email: $userEmail');
                                  }
                                  postUserIdd = document['uid'];
                                  ViewChat(postUserIdd);
                                },
                                child: Text('148'.tr),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
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
