import 'package:derot/locale/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Language extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyLocaleController controllerLang = Get.find();
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(height: 200),
          TextButton(
              onPressed: () {
                controllerLang.changeLang("en");
              },
              child: Text("4".tr)),
          TextButton(
              onPressed: () {
                controllerLang.changeLang("he");
              },
              child: Text("5".tr)),
          TextButton(
              onPressed: () {
                controllerLang.changeLang("ar");
              },
              child: Text("6".tr))
        ],
      ),
    );
  }
}
