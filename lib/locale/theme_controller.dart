import 'package:derot/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyThemeController extends GetxController {
  RxBool isDarkMode = (sharepref!.getBool("darkMode") ?? false).obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    sharepref!.setBool("darkMode", value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
