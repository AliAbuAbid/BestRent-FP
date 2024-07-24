// ignore_for_file: unused_import, unused_field

//import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/Customer/districtHouse.dart';
import 'package:derot/HouseRent/InProgress/custInProgress.dart';
import 'package:derot/HouseRent/InProgress/showContract.dart';
import 'package:derot/Payment/PaymentPage.dart';
import 'package:derot/drawerFunctions/support.dart';
import 'package:derot/drawerFunctions/terms&conditions.dart';

import 'package:derot/notifications.dart';
import 'package:derot/HouseRent/HouseEditor/bestOffers.dart';
import 'package:derot/HouseRent/HouseEditor/data.dart';
import 'package:derot/HouseRent/HouseEditor/myHouses.dart';
//////
// import 'package:derot/login11.dart';
/////
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

class DrawerShow extends StatefulWidget {
  const DrawerShow({Key? key}) : super(key: key);

  @override
  State<DrawerShow> createState() => homeScreenState();
}

class homeScreenState extends State<DrawerShow> {
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

  void showTerms() {
    Navigator.of(context).push(
      CustomPageRoute(
        pageBuilder: (context) => TermsAndConditionsPage(),
      ),
    );
  }

  void ViewAdd() {
    if (isLoggedIn) {
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => AddHouse(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('63'.tr),
        ),
      );
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => LoginPage(),
      ));
    }
  }

  void ViewChat() {
    if (isLoggedIn) {
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => Chats(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('63'.tr),
        ),
      );
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => LoginPage(),
      ));
    }
  }

  void ViewFavourites() {
    if (isLoggedIn) {
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => Favourites(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('63'.tr),
        ),
      );
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => LoginPage(),
      ));
    }
  }

  void SharedHouses() {
    if (isLoggedIn) {
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => MyHouse(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('63'.tr),
        ),
      );
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => LoginPage(),
      ));
    }
  }

  void CustHouse() {
    if (isLoggedIn) {
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => CustInProgress(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('63'.tr),
        ),
      );
      Navigator.of(context).push(CustomPageRoute(
        pageBuilder: (context) => LoginPage(),
      ));
    }
  }

  void Support() {
    Navigator.of(context).push(CustomPageRoute(
      pageBuilder: (context) => SupportPage(),
    ));
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

  void _AppSettings() {
    Navigator.of(context).push(CustomPageRoute(
      pageBuilder: (context) => AppPage(),
    ));
  }

  MyLocaleController controllerLang = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: Color.fromARGB(233, 234, 229, 229),
      child: Container(
        height: double.infinity,
        alignment: Alignment.topCenter,
        child: ListView(
          children: [
            //Card(
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoggedIn ? ProfilePhoto() : SizedBox(),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: FutureBuilder<String?>(
                future: getUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('');
                  } else {
                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        snapshot.data!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: Login,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          isLoggedIn ? '11'.tr : '7'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 40,
                  //  width: 100,
                  child: TextButton(
                    onPressed: ViewAdd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_home_outlined, color: Colors.black),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '8'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 40,
                  //  width: 100,
                  child: TextButton(
                    onPressed: SharedHouses,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_outlined, color: Colors.black),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '101'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 40,
                  // width: 100,
                  child: TextButton(
                    onPressed: ViewChat,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '9'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),

            Column(
              children: [
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: ViewFavourites,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ),
                        SizedBox(
                            width: 5), // Adjust spacing between icon and text
                        Text(
                          '62'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 68,
                  child: TextButton(
                    onPressed: CustHouse,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.other_houses_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '161'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 40,
                  //width: 100,
                  child: TextButton(
                    onPressed: _AppSettings,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          '2'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 40,
                  //width: 100,
                  child: TextButton(
                    onPressed: showTerms,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.policy, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          '133'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 40,
                  //width: 100,
                  child: TextButton(
                    onPressed: Support,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.support_agent_outlined, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          '176'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
