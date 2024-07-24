//import 'package:derot/Customer/Cities/beerSheva.dart';
import 'package:derot/Customer/Cities/editlang.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/Home.dart';
//import 'package:derot/login1.dart';
import 'package:derot/Users/ChangePassword.dart';
import 'package:derot/Users/deleteUser.dart';
import 'package:derot/Users/profileEdit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:derot/locale/locale_controller.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppSettings();
  }
}

class AppSettings extends State<AppPage> {
  //late String codelang;
  Languages _selectedLanguage = Languages.Hebrew;
  @override
  Widget build(BuildContext context) {
    MyLocaleController controllerLang = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(21, 0, 0, 1),
        title: Text(
          "2".tr,
          style: GoogleFonts.lato(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        //margin: EdgeInsets.only(left: 50),
        color: Color.fromARGB(21, 0, 0, 1),

        child: ListView(
          children: [
            SizedBox(height: 50),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 100),
                Text(
                  "3".tr,
                  style: GoogleFonts.lato(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  // textAlign: TextAlign.center,
                ),
                SizedBox(width: 10),
                DropdownButton(
                    value: _selectedLanguage,
                    items: Languages.values
                        .map(
                          (lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(
                              lang.stringValue.toString(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedLanguage = value;
                        //languages = _selectedLanguage;

                        // _selectedLanguage = 'ar';
                        if (_selectedLanguage.toString() ==
                            'Languages.English') {
                          controllerLang.changeLang('en');
                        } else if (_selectedLanguage.toString() ==
                            'Languages.Hebrew') {
                          controllerLang.changeLang('he');
                        } else if (_selectedLanguage.toString() ==
                            'Languages.Arabic') {
                          controllerLang.changeLang('ar');
                        }
                      });

                      if (_selectedLanguage == 'Languages.ar') {
                        // _selectedLanguage = 'ar';
                        controllerLang.changeLang('ar');
                      }
                    }),
                const Spacer(),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            isLoggedIn
                ? Column(
                    children: [
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(CustomPageRoute(
                              pageBuilder: (context) => ForgetPage(),
                            ));
                          },
                          child: Text(
                            "82".tr,
                            style: GoogleFonts.lato(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(CustomPageRoute(
                              pageBuilder: (context) => EditUser(),
                            ));
                          },
                          child: Text(
                            "85".tr,
                            style: GoogleFonts.lato(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(CustomPageRoute(
                              pageBuilder: (context) => DeleteUsers(),
                            ));
                          },
                          child: Text(
                            "83".tr,
                            style: GoogleFonts.lato(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
