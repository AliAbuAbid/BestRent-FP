// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('176'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              '177'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                '177'.tr,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              children: [
                ListTile(
                  title: Text(
                    '178'.tr,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  onTap: () {
                    // Add onTap functionality to show answer or navigate to answer page
                  },
                ),
                ListTile(
                  title: Text(
                    '178'.tr,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  onTap: () {},
                ),

                // Add more FAQs as needed
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '179'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            const ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'support@example.com',
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.email),
                  ),
                ],
              ),
              // onTap: () async {
              //   final Uri _emailLaunchUri = Uri(
              //     scheme: 'mailto',
              //     path: 'support@example.com',
              //     queryParameters: {'subject': 'בקשת תמיכה'},
              //   );
              //   if (await canLaunch(_emailLaunchUri.toString())) {
              //     await launch(_emailLaunchUri.toString());
              //   } else {
              //     throw 'לא ניתן לפתוח אימייל';
              //   }
              // },
            ),
            const SizedBox(height: 20),
            Text(
              '180'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to ticket submission form
                // Navigator.push(
                //     (context),
                //     MaterialPageRoute(
                //         builder: (context) => SubmitTicketPage()));
              },
              child: Text(
                '180'.tr,
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '181'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: Text(
                '182'.tr,
                textDirection: TextDirection.rtl,
              ),
              onTap: () {
                // Navigate to user guides
                // Navigator.push((context),
                //     MaterialPageRoute(builder: (context) => UserManualPage()));
              },
            ),
            const SizedBox(height: 20),
            Text(
              '183'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to feedback form
                // Navigator.push((context),
                //     MaterialPageRoute(builder: (context) => FeedbackForm()));
              },
              child: Text(
                '184'.tr,
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '185'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      launch('https://www.linkedin.com/in/eyad-jbaren/');
                    },
                    child: SvgPicture.asset(
                      'assets/icons/linkedin.svg',
                      //width: 30,
                    )),
                TextButton(
                  onPressed: () {
                    launch('https://www.instagram.com/');
                  },
                  child: SvgPicture.asset(
                    'assets/icons/instagram.svg',
                    // width: 30,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      launch('https://www.facebook.com/?locale=he_IL');
                    },
                    child: SvgPicture.asset(
                      'assets/icons/facebook.svg',
                      //  width: 30,
                    ))
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '186'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement error reporting functionality
              },
              child: Text(
                '186'.tr,
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '134'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text(
                '134'.tr,
                textDirection: TextDirection.rtl,
              ),
              onTap: () {
                // Navigate to privacy policy page
              },
            ),
          ],
        ),
      ),
    );
  }
}
