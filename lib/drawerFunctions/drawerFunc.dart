// ignore_for_file: unused_import, unused_field, deprecated_member_use

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
import 'package:derot/DataBase/PushNotificationService.dart';
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
bool love = false;

class DrawerShow extends StatefulWidget {
  const DrawerShow({Key? key}) : super(key: key);

  @override
  State<DrawerShow> createState() => homeScreenState();
}

class homeScreenState extends State<DrawerShow> {
  static const Color _accent = Color(0xFF0D47A1);

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
      if (isLoggedIn == true) {
        // Logout
        await PushNotificationService.clearTokenForCurrentUser();
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

  void _AppSettings() {
    Navigator.of(context).push(CustomPageRoute(
      pageBuilder: (context) => AppPage(),
    ));
  }

  MyLocaleController controllerLang = Get.find();

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    Color? iconColor,
    Widget? trailing,
  }) {
    final Color color = iconColor ?? _accent;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalUnreadBadge() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();
    final String currentUid = user.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatThreads')
          .where('participants', arrayContains: currentUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        int total = 0;
        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          total += ((data['unreadCount_$currentUid'] as num?)?.toInt() ?? 0);
        }
        if (total <= 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            total > 99 ? '99+' : total.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color dividerColor = isDark ? Colors.white12 : Colors.grey.shade200;
    return Drawer(
      width: 265,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF26C6DA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: isLoggedIn
                          ? ProfilePhoto()
                          : const Padding(
                              padding: EdgeInsets.all(14),
                              child:
                                  Icon(Icons.person, size: 32, color: _accent),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<String?>(
                    future: getUsername(),
                    builder: (context, snapshot) {
                      final String display = (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty)
                          ? snapshot.data!
                          : '';
                      return Text(
                        display,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 12),
                children: [
                  const SizedBox(height: 6),
                  _drawerItem(
                    isDark: isDark,
                    icon: isLoggedIn ? Icons.logout : Icons.login,
                    label: isLoggedIn ? '11'.tr : '7'.tr,
                    iconColor: isLoggedIn ? Colors.redAccent : _accent,
                    onTap: Login,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: dividerColor, height: 1),
                  ),
                  const SizedBox(height: 10),
                  _drawerItem(
                    isDark: isDark,
                    icon: Icons.add_home_outlined,
                    label: '8'.tr,
                    onTap: ViewAdd,
                  ),
                  _drawerItem(
                    isDark: isDark,
                    icon: Icons.home_outlined,
                    label: '101'.tr,
                    onTap: SharedHouses,
                  ),
                  _drawerItem(
                    isDark: isDark,
                    icon: Icons.other_houses_outlined,
                    label: '161'.tr,
                    onTap: CustHouse,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: dividerColor, height: 1),
                  ),
                  const SizedBox(height: 10),
                  _drawerItem(
                    isDark: isDark,
                    icon: Icons.chat_outlined,
                    label: '9'.tr,
                    onTap: ViewChat,
                    trailing: _buildTotalUnreadBadge(),
                  ),
                  _drawerItem(
                    isDark: isDark,
                    icon: Icons.favorite_border,
                    label: '62'.tr,
                    onTap: ViewFavourites,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: dividerColor, height: 1),
                  ),
                  _drawerItem(
                    isDark: isDark,
                    icon: Icons.settings_outlined,
                    label: '2'.tr,
                    onTap: _AppSettings,
                  ),
                  _drawerItem(
                    isDark: isDark,
                    icon: Icons.policy_outlined,
                    label: '133'.tr,
                    onTap: showTerms,
                  ),
                  _drawerItem(
                    isDark: isDark,
                    icon: Icons.support_agent_outlined,
                    label: '176'.tr,
                    onTap: Support,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
