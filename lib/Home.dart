// ignore_for_file: unused_import, unused_field, deprecated_member_use

//import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/AIChat/AIChatPage.dart';
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
bool love = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => homeScreenState();
}

class homeScreenState extends State<HomePage> {
  final LayerLink _notifLink = LayerLink();
  OverlayEntry? _notifOverlay;

  @override
  void initState() {
    super.initState();
    isLoggedIn = SharedPreferencesService.isLoggedIn();
  }

  @override
  void dispose() {
    _notifOverlay?.remove();
    super.dispose();
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

  void _closeNotifications() {
    _notifOverlay?.remove();
    _notifOverlay = null;
  }

  void _showNotifications() {
    if (_notifOverlay != null) {
      _closeNotifications();
      return;
    }
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    _notifOverlay = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeNotifications,
              ),
            ),
            CompositedTransformFollower(
              link: _notifLink,
              showWhenUnlinked: false,
              targetAnchor:
                  isRtl ? Alignment.bottomLeft : Alignment.bottomRight,
              followerAnchor: isRtl ? Alignment.topLeft : Alignment.topRight,
              offset: const Offset(0, 10),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: 300,
                  constraints: const BoxConstraints(maxHeight: 380),
                  child: NotificationsScreen(),
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context).insert(_notifOverlay!);
  }

  MyLocaleController controllerLang = Get.find();
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: DrawerShow(),
      body: Stack(
        children: [
          Container(
            height: 200.8,
            color: Color.fromARGB(21, 0, 0, 1),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 25, 16, 20),
                decoration: isDark
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            //  Color.fromARGB(255, 255, 255, 255),
                            Color(0xFF26C6DA),
                            Color(0xFF1E88E5),
                            Color(0xFF0D47A1),
                            Color.fromARGB(255, 5, 60, 143),
                            Color.fromARGB(255, 4, 41, 92),
                          ],
                        ),
                      )
                    : BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 4, 35, 79),
                            Color.fromARGB(255, 5, 60, 143),
                            Color(0xFF0D47A1),
                            Color(0xFF1E88E5),
                            Color(0xFF26C6DA),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                      ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 🔹 Top Row (☰ Menu start, Logo centered, 🔔 Bell end)

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// ☰ Menu
                        Builder(
                          builder: (ctx) => InkWell(
                            onTap: () => Scaffold.of(ctx).openDrawer(),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(.18)
                                    : Colors.white.withOpacity(.18),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(Icons.menu, color: Colors.white),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseAuth.instance.currentUser ==
                                            null
                                        ? null
                                        : FirebaseFirestore.instance
                                            .collection('chatThreads')
                                            .where('participants',
                                                arrayContains: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox.shrink();
                                      }
                                      final String currentUid = FirebaseAuth
                                          .instance.currentUser!.uid;
                                      int total = 0;
                                      for (var doc in snapshot.data!.docs) {
                                        final data =
                                            doc.data() as Map<String, dynamic>;
                                        total +=
                                            ((data['unreadCount_$currentUid']
                                                        as num?)
                                                    ?.toInt() ??
                                                0);
                                      }
                                      if (total <= 0) {
                                        return const SizedBox.shrink();
                                      }
                                      return Positioned(
                                        top: 10,
                                        right: 12,
                                        child: Container(
                                          width: 9,
                                          height: 9,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        /// 🤖 Chat with AI
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(CustomPageRoute(
                              pageBuilder: (context) => const AIChatPage(),
                            ));
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.18),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Icon(Icons.smart_toy_outlined,
                                color: Colors.white),
                          ),
                        ),

                        /// 🏠 Logo + tagline (centered)
                        Expanded(
                          child: Center(
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.18),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.home_rounded,
                                        color: Colors.white, size: 22),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Best",
                                                style: GoogleFonts.lato(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Rent",
                                                style: GoogleFonts.lato(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color.fromARGB(
                                                      255, 25, 209, 233),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '192'.tr,
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withOpacity(.85),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// 🔔 Notifications
                        CompositedTransformTarget(
                          link: _notifLink,
                          child: InkWell(
                            onTap: () {
                              _showNotifications();
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.18),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(Icons.notifications_none,
                                      color: Colors.white),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseAuth.instance.currentUser ==
                                            null
                                        ? null
                                        : FirebaseFirestore.instance
                                            .collection('notifications')
                                            .where('email',
                                                isEqualTo: FirebaseAuth.instance
                                                    .currentUser!.email)
                                            .where('read', isEqualTo: false)
                                            .snapshots(),
                                    builder: (context, snapshot) {
                                      final bool hasUnread = snapshot.hasData &&
                                          snapshot.data!.docs.isNotEmpty;
                                      if (!hasUnread) {
                                        return const SizedBox.shrink();
                                      }
                                      return Positioned(
                                        top: 10,
                                        right: 12,
                                        child: Container(
                                          width: 9,
                                          height: 9,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Container(
                      padding: EdgeInsets.only(top: 6),
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _cityChip(
                            cityKey: 'telaviv_jaffa',
                            label: '120'.tr,
                            imageAsset: 'assets/images/telaviv.jpg',
                            onTap: () {
                              setState(() => selectedCityKey = 'telaviv_jaffa');
                              selectedDistrict = 'TelAviv-Java';
                              distLang = 'telaviv_jaffa';
                              Navigator.of(context).push(CustomPageRoute(
                                pageBuilder: (context) => DistrictApp(),
                              ));
                            },
                          ),
                          _cityChip(
                            cityKey: 'center',
                            label: '119'.tr,
                            imageAsset: 'assets/images/center.jpg',
                            onTap: () {
                              setState(() => selectedCityKey = 'center');
                              selectedDistrict = 'Center';
                              distLang = 'center';
                              Navigator.of(context).push(CustomPageRoute(
                                pageBuilder: (context) => DistrictApp(),
                              ));
                            },
                          ),
                          _cityChip(
                            cityKey: 'haifa',
                            label: '118'.tr,
                            imageAsset: 'assets/images/haifa.jpg',
                            onTap: () {
                              setState(() => selectedCityKey = 'haifa');
                              selectedDistrict = 'Haifa';
                              distLang = 'haifa';
                              Navigator.of(context).push(CustomPageRoute(
                                pageBuilder: (context) => DistrictApp(),
                              ));
                            },
                          ),
                          _cityChip(
                            cityKey: 'north',
                            label: '117'.tr,
                            imageAsset: 'assets/images/north.jpg',
                            onTap: () {
                              setState(() => selectedCityKey = 'north');
                              selectedDistrict = 'North';
                              distLang = 'north';
                              Navigator.of(context).push(CustomPageRoute(
                                pageBuilder: (context) => DistrictApp(),
                              ));
                            },
                          ),
                          _cityChip(
                            cityKey: 'jerusalem',
                            label: '121'.tr,
                            imageAsset: 'assets/images/jeruzalim.jpg',
                            onTap: () {
                              setState(() => selectedCityKey = 'jerusalem');
                              selectedDistrict = 'Jerusalem';
                              distLang = 'jerusalem';
                              Navigator.of(context).push(CustomPageRoute(
                                pageBuilder: (context) => DistrictApp(),
                              ));
                            },
                          ),
                          _cityChip(
                            cityKey: 'south',
                            label: '122'.tr,
                            imageAsset: 'assets/images/south.jpg',
                            onTap: () {
                              setState(() => selectedCityKey = 'south');
                              selectedDistrict = 'South';
                              distLang = 'south';
                              Navigator.of(context).push(CustomPageRoute(
                                pageBuilder: (context) => DistrictApp(),
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /////
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '111'.tr + ' ',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Text('✨', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: isDark ? const Color(0xFF121212) : Colors.white,
                  child: BestOffers(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String selectedCityKey = 'all';

  Widget _cityChip({
    required String cityKey,
    required String label,
    String? imageAsset,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    final bool isSelected = selectedCityKey == cityKey;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 78,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 70,
                    height: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1E88E5)
                            : Colors.transparent,
                        width: 2,
                      ),
                      color:
                          imageAsset == null ? const Color(0xFF0D47A1) : null,
                    ),
                    child: imageAsset == null
                        ? Icon(icon, color: Colors.white, size: 26)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              imageAsset,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E88E5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.lato(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
