// ignore_for_file: unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Calls extends StatefulWidget {
  @override
  _Calls createState() => _Calls();
}

class _Calls extends State<Calls> {
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _makeCall(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('10'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                const phone = '+972549927489';
                if (await canLaunch('tel:$phone')) {
                  await launch('tel:$phone');
                } else {
                  throw 'Could not launch $phone';
                }
              },
              child: Text('Call'),
            ),
          ],
        ),
      ),
    );
  }
}
