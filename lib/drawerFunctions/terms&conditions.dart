// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:derot/DataBase/Transition.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('134'.tr),
      // ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              //color: Color.fromARGB(255, 239, 239, 242),
              gradient: LinearGradient(
                begin: Alignment
                    .topCenter, // Alignment of the gradient's starting point
                end: Alignment
                    .bottomCenter, // Alignment of the gradient's ending point
                colors: [
                  Color.fromARGB(0, 214, 214, 214),
                  Color.fromARGB(255, 230, 231, 238),
                  Color.fromARGB(255, 231, 230, 236),
                  Color.fromARGB(255, 216, 216, 219),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    '135'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '136'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '137'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '138'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '139'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '140'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '141'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '142'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '143'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '144'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '145'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '146'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  //color: Color.fromARGB(255, 239, 239, 242),
                  gradient: LinearGradient(
                    begin: Alignment
                        .topCenter, // Alignment of the gradient's starting point
                    end: Alignment
                        .bottomCenter, // Alignment of the gradient's ending point
                    colors: [
                      Color.fromARGB(255, 252, 252, 255),
                      Color.fromARGB(255, 230, 231, 238),
                      //  Color.fromARGB(255, 231, 230, 236),
                      //Color.fromARGB(255, 216, 216, 219),
                    ],
                  ),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Center(
                    child: Text(
                      '134'.tr + '             ',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
