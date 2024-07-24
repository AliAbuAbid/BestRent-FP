// ignore_for_file: unused_import, unnecessary_import, unnecessary_cast, unused_local_variable, unused_element

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/HouseRent/HouseEditor/houseEdit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ShowData extends StatefulWidget {
  const ShowData({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<ShowData> {
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('apartments').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              List<Widget> cards = [];

              snapshot.data!.docs.forEach((document) {
                String address = document['email'];
                String city = document['city'];
                bool pets = document['Pets'];
                bool renovated = document['Renovated'];
                bool shelter = document['Shelter'];
                String building = document['building'];
                String district = document['district'];
                String explain = document['explain'];
                bool storage = document['Storage'];
                bool accessForDisabled = document['AccessForDisabled'];
                bool airCondition = document['AirCondition'];
                bool bars = document['Bars'];
                bool exclusiveProperty = document['LongTerm'];
                bool furniture = document['Furniture'];
                bool heater = document['Heater'];
                bool longTerm = document['LongTerm'];
                String house = document['house'];
                String phone = document['phone'];
                String price = document['price'];
                String street = document['street'];
                String floar = document['floar'];
                String streetNumber = document['streetNumber'];
                String username = document['username'];
                bool flexible = document['flexible'];

                String documentId = document.id;

                cards.add(
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          35), // Adjust the radius as needed
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('17'.tr + ': ' + document['username']),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('73'.tr + ': ' + document['phone']),
                        SizedBox(
                          height: 10,
                        ),
                        Text('18'.tr + ': ' + document['email']),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('35'.tr + ': ' + document['street']),
                            SizedBox(width: 10),
                            Text(' | '),
                            SizedBox(width: 10),
                            Text('42'.tr + ': ' + document['streetNumber']),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('34'.tr + ' ' + document['city']),
                            SizedBox(width: 10),
                            Text(' | '),
                            SizedBox(width: 10),
                            Text('50'.tr + ': ' + document['house']),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('41'.tr + ': ' + document['district']),
                        //////////////////////
                        ///fdfdfd

                        ////////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('104'.tr + ': ' + document['building']),
                            SizedBox(width: 10),
                            Text(' | '),
                            SizedBox(width: 10),
                            Text('31'.tr + ' ' + document['rooms']),
                            SizedBox(width: 10),
                            Text('109'.tr + ' ' + document['floar']),
                            SizedBox(width: 10),
                          ],
                        ),

                        SizedBox(height: 10),
                        Text('30'.tr + ' ' + document['price']),
                        SizedBox(height: 10),

                        Text('39'.tr + ': ' + document['explain']),
                        SizedBox(
                          height: 10,
                        ),

                        FutureBuilder<List<String>>(
                          future: _getImages(documentId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('No images found');
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: snapshot.data!.map((imageUrl) {
                                    return Image.network(
                                      imageUrl,
                                      width: 100,
                                      height: 150,
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: document['Pets']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/pet.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '96'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/pet.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '96'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            /////////////////////////////////
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: document['Renovated']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/revonated.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '93'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/revonated.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '93'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 20,
                            ),

                            /////////////////////////////////
                            Expanded(
                              flex: -2,
                              child: document['Shelter']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/shelter.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '94'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/shelter.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '94'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        /////////////////////////////////
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: document['Storage']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/storage.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '95'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/storage.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '95'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            /////////////////////////////////
                            Expanded(
                              child: document['flexible']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/flexible.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '98'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/flexible.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '98'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 20,
                            ),

                            /////////////////////////////////
                            Expanded(
                              flex: -2,
                              child: document['AccessForDisabled']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/access.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '92'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/access.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '92'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        /////////////////////////////////
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: document['AirCondition']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/snow.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '102'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/snow.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '102'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            /////////////////////////////////
                            Expanded(
                              flex: 2,
                              child: document['Bars']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/bars.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '90'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/bars.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '90'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            /////////////////////////////////
                            // SizedBox(
                            //   width: 20,
                            // ),
                            Expanded(
                              flex: -2,
                              child: document['ExclusiveProperty']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/exclusive.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '88'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/exclusive.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '88'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(height: 10),
                        /////////////////////////////////
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: document['Furniture']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/furniture.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '97'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/furniture.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '97'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            /////////////////////////////////
                            Expanded(
                              child: document['Heater']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/heater.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '91'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/heater.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '91'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 20,
                            ),

                            /////////////////////////////////
                            Expanded(
                              flex: -2,
                              child: document['LongTerm']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/longTerm.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: const Color.fromARGB(255, 0, 0,
                                              0), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '99'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/longTerm.svg',
                                          // Path to your SVG file
                                          width:
                                              18, // Adjust the width as needed
                                          height:
                                              18, // Adjust the height as needed
                                          // ignore: deprecated_member_use
                                          color: Color.fromARGB(255, 191, 180,
                                              180), // Set the color of the icon
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '99'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 191, 180, 180),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       child: MaterialButton(
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(10),
                        //           side: const BorderSide(
                        //               color: Color.fromARGB(121, 0, 0, 0),
                        //               width: 2.0),
                        //         ),
                        //         color: Color.fromARGB(255, 255, 255, 255),
                        //         colorBrightness: Brightness.dark,
                        //         onPressed: editHouse, //() {
                        //         //   Navigator.of(context)
                        //         //       .pushReplacementNamed('/login');
                        //         // },
                        //         child: Text(
                        //           '103'.tr,
                        //           style: const TextStyle(
                        //               color: Color.fromARGB(255, 0, 0, 0),
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(width: 20),
                        //     Container(
                        //       child: MaterialButton(
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(10),
                        //           side: const BorderSide(
                        //               color: Color.fromARGB(121, 0, 0, 0),
                        //               width: 2.0),
                        //         ),
                        //         color: Color.fromARGB(255, 255, 255, 255),
                        //         colorBrightness: Brightness.dark,
                        //         onPressed: () async {
                        //           print(
                        //               '\n\n\n\n\nThis is My Fucking Document: documents\n\n\n\n\n\n\n');
                        //           deleteFolder('images/$documentId');
                        //           await document.reference.delete();
                        //         }, //() {
                        //         //   Navigator.of(context)
                        //         //       .pushReplacementNamed('/login');
                        //         // },
                        //         child: Text(
                        //           '105'.tr,
                        //           style: const TextStyle(
                        //               color: Color.fromARGB(255, 0, 0, 0),
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        /////////////////////////////////
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              });

              return ListView(
                children: cards,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<List<String>> _getImages(String documentId) async {
    List<String> imageUrls = [];
    Reference imagesRef =
        FirebaseStorage.instance.ref().child('images/$documentId');
    try {
      ListResult result = await imagesRef.listAll();
      for (Reference ref in result.items) {
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Error loading images: $e');
    }
    return imageUrls;
  }

  // Future<void> deleteImage(String documentId) async {
  //   //tapped = false;

  //   // try {
  //   //   // Create a reference to the file to delete
  //   //  // final user = FirebaseAuth.instance.currentUser;
  //   //   Reference storageRef =
  //   //       FirebaseStorage.instance.ref().child('images/$documentId');

  //   //   // Delete the file
  //   //   await storageRef.delete();

  //   //   print('Image deleted successfully');
  //   // } catch (e) {
  //   //   print('Error deleting image: $e');
  //   // }
  // }
  // Future<void> deleteFolder(String folderPath) async {
  //   Reference folderRef = FirebaseStorage.instance.ref().child(folderPath);

  //   try {
  //     // List all items (files and subdirectories) in the folder
  //     ListResult listResult = await folderRef.listAll();

  //     // Delete each item (file or subdirectory)
  //     for (Reference ref in listResult.items) {
  //       // If the item is a subdirectory, recursively delete its contents
  //       if (ref.fullPath.endsWith('/')) {
  //         await deleteFolder(ref.fullPath);
  //       } else {
  //         // If the item is a file, delete it
  //         await ref.delete();
  //       }
  //     }

  //     // After deleting all contents, delete the folder itself
  //     await folderRef.delete();
  //     print('Folder deleted successfully: $folderPath');
  //   } catch (e) {
  //     print('Error deleting folder: $e');
  //   }
  // }

  // void editHouse() {
  //   Navigator.of(context).push(CustomPageRoute(
  //     pageBuilder: (context) => EditHouse(),
  //   ));
  // }
}
