// ignore_for_file: unused_import, unused_field

//import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/Customer/districtHouse.dart';
import 'package:derot/HouseRent/InProgress/custInProgress.dart';
import 'package:derot/HouseRent/InProgress/showContract.dart';
import 'package:derot/Payment/PaymentPage.dart';
import 'package:derot/drawerFunctions/drawerFunc.dart';
import 'package:derot/drawerFunctions/support.dart';
import 'package:derot/drawerFunctions/terms&conditions.dart';

import 'package:derot/notifications.dart';
import 'package:derot/HouseRent/HouseEditor/bestOffers.dart';
import 'package:derot/HouseRent/HouseEditor/data.dart';
import 'package:derot/HouseRent/HouseEditor/myHouses.dart';

import 'package:derot/drawerFunctions/Favourites.dart';
import 'package:derot/drawerFunctions/chats.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:derot/drawerFunctions/new-apartment.dart';
import 'package:derot/drawerFunctions/appSettings.dart';
import 'package:derot/main.dart';
import 'package:derot/DataBase/sharedPrefences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/Users/login.dart';
import 'package:derot/Users/profilephoto.dart';
import 'package:derot/locale/locale_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoggedIn = false;
bool notifications = newnot;
bool love = false;
bool newnot = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => homeScreenState();
}

class homeScreenState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    isLoggedIn = SharedPreferencesService.isLoggedIn();
  }

  Future<String?> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          String username = data['username'];
          return username;
        } else {
          print('');
          return null;
        }
      } catch (e) {
        print('Error getting username: $e');
        return null;
      }
    } else {
      print('No user signed in.');
      return null;
    }
  }

  void Login() async {
    setState(() async {
      if (isLoggedIn) {
        // Logout
        await FirebaseAuth.instance.signOut();
        SharedPreferencesService.setLoggedIn(false);
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false); //Checking
      } else {
        //Login
        // Navigator.of(context).pushReplacementNamed('/login');

        Navigator.of(context).push(CustomPageRoute(
          pageBuilder: (context) => LoginPage(),
        ));
        isLoggedIn = !isLoggedIn;
      }
      isLoggedIn = !isLoggedIn;
    });
  }

  void _showNotifications() {
    newnot = false;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: NotificationsScreen(),
        );
      },
    );
  }

  MyLocaleController controllerLang = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerShow(),
      body: Stack(
        children: [
          Container(
            height: 200.8,
            color: Color.fromARGB(21, 0, 0, 1),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Color.fromARGB(21, 0, 0, 1),
                    elevation: 0,
                    title: Center(
                      child: Text(
                        'BestRent',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    actions: [
                      newnot
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  newnot = false;
                                });
                                _showNotifications();
                              },
                              icon: Stack(
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Positioned(
                                      child: Icon(Icons.brightness_1,
                                          color: Colors.red, size: 9)),
                                ],
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  newnot = false;
                                });
                                _showNotifications();
                              },
                              icon: Icon(
                                Icons.notifications,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(0, 255, 255, 255),
                    ),
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  selectedDistrict = 'North';
                                  distLang = 'north';
                                  Navigator.of(context).push(CustomPageRoute(
                                    pageBuilder: (context) => DistrictApp(),
                                  ));
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/north.jpg',
                                    width: 70.0,
                                    height: 70.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '117'.tr,
                                style: GoogleFonts.lato(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    //  fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                // height: 30,
                                width: 110,
                              ),
                              InkWell(
                                onTap: () {
                                  selectedDistrict = 'Haifa';
                                  distLang = 'haifa';

                                  Navigator.of(context).push(CustomPageRoute(
                                    pageBuilder: (context) => DistrictApp(),
                                  ));
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/haifa.jpg',
                                    width: 70.0,
                                    height: 70.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '118'.tr,
                                style: GoogleFonts.lato(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    //  fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   //  height: 30,
                              //   width: 110,
                              // ),
                              InkWell(
                                onTap: () {
                                  selectedDistrict = 'Center';
                                  distLang = 'center';

                                  Navigator.of(context).push(CustomPageRoute(
                                    pageBuilder: (context) => DistrictApp(),
                                  ));
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/center.jpg',
                                    width: 70.0,
                                    height: 70.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '119'.tr,
                                style: GoogleFonts.lato(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    //  fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                // height: 30,
                                width: 110,
                              ),
                              InkWell(
                                onTap: () {
                                  selectedDistrict = 'TelAviv-Java';
                                  distLang = 'telaviv_jaffa';

                                  Navigator.of(context).push(CustomPageRoute(
                                    pageBuilder: (context) => DistrictApp(),
                                  ));
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/telaviv.jpg',
                                    width: 70.0,
                                    height: 70.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '120'.tr,
                                style: GoogleFonts.lato(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    //  fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                //  height: 30,
                                width: 80,
                              ),
                              InkWell(
                                onTap: () {
                                  selectedDistrict = 'Jerusalem';
                                  distLang = 'jerusalem';

                                  Navigator.of(context).push(CustomPageRoute(
                                    pageBuilder: (context) => DistrictApp(),
                                  ));
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/jeruzalim.jpg',
                                    width: 70.0,
                                    height: 70.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '121'.tr,
                                style: GoogleFonts.lato(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    //  fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                //height: 30,
                                width: 110,
                              ),
                              InkWell(
                                onTap: () {
                                  selectedDistrict = 'South';
                                  distLang = 'south';

                                  Navigator.of(context).push(CustomPageRoute(
                                    pageBuilder: (context) => DistrictApp(),
                                  ));
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/south.jpg',
                                    width: 70.0,
                                    height: 70.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '122'.tr,
                                style: GoogleFonts.lato(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    //  fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Color.fromARGB(69, 0, 0, 0),
                    thickness: 1.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height - 220,
                    color: Color.fromARGB(21, 0, 0, 1),
                    child: BestOffers(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
