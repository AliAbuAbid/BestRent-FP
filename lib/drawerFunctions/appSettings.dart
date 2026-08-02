//import 'package:derot/Customer/Cities/beerSheva.dart';
// ignore_for_file: deprecated_member_use

import 'package:derot/Customer/Cities/editlang.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/Home.dart';
//import 'package:derot/login1.dart';
import 'package:derot/Users/ChangePassword.dart';
import 'package:derot/Users/deleteUser.dart';
import 'package:derot/Users/profileEdit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:derot/locale/locale_controller.dart';
import 'package:derot/locale/theme_controller.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppSettings();
  }
}

class AppSettings extends State<AppPage> {
  static const Color _accent = Color(0xFF0D47A1);

  //late String codelang;
  Languages _selectedLanguage = Languages.Hebrew;

  Widget _sectionCard(BuildContext context, {required List<Widget> children}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      indent: 60,
      color: isDark ? Colors.white12 : Colors.grey.shade200,
    );
  }

  Widget _settingsRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = iconColor ?? _accent;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  @override
  Widget build(BuildContext context) {
    MyLocaleController controllerLang = Get.find();
    MyThemeController controllerTheme = Get.find();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('2'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionCard(context, children: [
              _settingsRow(
                context: context,
                icon: Icons.language,
                label: '3'.tr,
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<Languages>(
                    value: _selectedLanguage,
                    items: Languages.values
                        .map(
                          (lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang.stringValue.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedLanguage = value;
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
                    },
                  ),
                ),
              ),
              _divider(context),
              Obx(
                () => _settingsRow(
                  context: context,
                  icon: Icons.dark_mode_outlined,
                  label: '220'.tr,
                  trailing: Switch(
                    value: controllerTheme.isDarkMode.value,
                    onChanged: controllerTheme.toggleTheme,
                    activeThumbColor: _accent,
                  ),
                ),
              ),
            ]),
            if (isLoggedIn)
              _sectionCard(context, children: [
                _settingsRow(
                  context: context,
                  icon: Icons.lock_outline,
                  label: '82'.tr,
                  trailing: Icon(Icons.chevron_right,
                      color: isDark ? Colors.white38 : Colors.black38),
                  onTap: () {
                    Navigator.of(context).push(CustomPageRoute(
                      pageBuilder: (context) => ForgetPage(),
                    ));
                  },
                ),
                _divider(context),
                _settingsRow(
                  context: context,
                  icon: Icons.edit_outlined,
                  label: '85'.tr,
                  trailing: Icon(Icons.chevron_right,
                      color: isDark ? Colors.white38 : Colors.black38),
                  onTap: () {
                    Navigator.of(context).push(CustomPageRoute(
                      pageBuilder: (context) => EditUser(),
                    ));
                  },
                ),
                _divider(context),
                _settingsRow(
                  context: context,
                  icon: Icons.delete_outline,
                  label: '83'.tr,
                  iconColor: Colors.redAccent,
                  trailing: Icon(Icons.chevron_right,
                      color: isDark ? Colors.white38 : Colors.black38),
                  onTap: () {
                    Navigator.of(context).push(CustomPageRoute(
                      pageBuilder: (context) => DeleteUsers(),
                    ));
                  },
                ),
              ]),
          ],
        ),
      ),
    );
  }
}
