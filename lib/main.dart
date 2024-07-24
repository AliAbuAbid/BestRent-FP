//import 'package:derot/Home.dart';
// ignore_for_file: unused_element, unused_import

import 'package:derot/Home.dart';
import 'package:derot/HouseRent/HouseEditor/myHouses.dart';
import 'package:derot/Users/Register.dart';
import 'package:derot/Users/login.dart';
//import 'package:derot/login11.dart';
//import 'package:derot/HouseRent/login1.dart';
import 'package:derot/drawerFunctions/new-apartment.dart';
import 'package:derot/locale/locale.dart';
import 'package:derot/locale/locale_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'DataBase/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:derot/DataBase/sharedPrefences.dart';

SharedPreferences? sharepref;
SharedPreferences? profile;
//bool logedIn = false;
bool isLoggedIn = false;
String documents = '12';
bool newnot = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  sharepref = await SharedPreferences.getInstance();
  //await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate(
  //   webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  // );
  //loggedIn = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  bool isLightTheme = false;
  @override
  Widget build(BuildContext context) {
    MyLocaleController controller = Get.put(MyLocaleController());
    Get.put(MyLocaleController());
    @override
    void initState() {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print('=========>User is currently signed out!');
        } else {
          print('=========>User is signed in!');
        }
      });
      super.initState();
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'derot',
      //theme: ThemeData(useMaterial3: true),
      //home: SharedPreferencesService.isLoggedIn() ? HomePage() : LoginPage(),
      //     FirebaseAuth.instance.currentUser == null ? LoginPage() : HomePage(),
      // initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        'register': (context) => RegistrationPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        //'/addedHouse': (context) => MyHouse(),
      },
      locale: controller.initialLang,
      translations: MyLocale(),
    );
  }
}
