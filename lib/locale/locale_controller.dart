import 'package:derot/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MyLocaleController extends GetxController {
  Locale initialLang = sharepref!.getString("lang") == "ar"
      ? Locale("ar")
      : (sharepref!.getString("lang") == "en" ? Locale("en") : Locale("he"));

  void changeLang(String codelang) {
    Locale locale = Locale(codelang);
    sharepref!.setString("lang", codelang);
    Get.updateLocale(locale);
  }
}
