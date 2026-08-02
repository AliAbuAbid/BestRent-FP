//import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

//enum Languages { English, Arabic, Hebrew }
enum Languages { English, Arabic, Hebrew }

extension LanguagesExtension on Languages {
  String get stringValue {
    switch (this) {
      case Languages.English:
        return '4'.tr;
      case Languages.Hebrew:
        return '5'.tr;
      case Languages.Arabic:
        return '6'.tr;
    }
  }
}

class LanguageEdit {
  LanguageEdit({
    required this.language,
  });

  final Languages language;
}
