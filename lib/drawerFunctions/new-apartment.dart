// // // ignore_for_file: unused_local_variable, unused_import, unused_field

// ignore_for_file: unused_field, unused_import, duplicate_ignore, deprecated_member_use, unused_element, unused_local_variable, unnecessary_import

import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/HouseRent/ApartmentIcons.dart';
import 'package:derot/HouseRent/HouseEditor/myHouses.dart';
import 'package:derot/Users/login.dart';
import 'package:derot/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

String postUserId = '';

class AddHouse extends StatefulWidget {
  const AddHouse({Key? key}) : super(key: key);

  @override
  State<AddHouse> createState() => _AddHouse();
}

class _AddHouse extends State<AddHouse> {
  final _formKey = GlobalKey<FormState>();
  Kind _selectedhouse = Kind.partners;
  States _selectedstate = States.center;
  TextEditingController _cityController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _streetnController = TextEditingController();
  TextEditingController _expController = TextEditingController();
  TextEditingController _building = TextEditingController();
  TextEditingController _floar = TextEditingController();
  TextEditingController _rooms = TextEditingController();
  TextEditingController _price = TextEditingController();
  int? imageIndex;
  int documentCount = 0;

  String userEmail = '';
  String userPhone = '';
  String userFullname = '';

  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;
  bool _isChecked6 = false;
  bool _isChecked7 = false;
  bool _isChecked8 = false;
  bool _isChecked9 = false;
  bool _isChecked10 = false;
  bool _isChecked11 = false;
  bool _isChecked12 = false;
  Map<String, double> raters = {'a': 0.1};

  //Kind house;
  List<String> downloadUrls = [];
  List<File> _images = [];
  bool showImages = false;
  late String document;
  int k = 0;
  DateTime currentDate = DateTime.now();

  int? selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  Future<void> changeImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        if (selectedImage != null) {
          _images[selectedImage!] = File(image.path);
        }
        _images.add(File(image.path));
        showImages = true;
      });
    }
  }

  void _add() async {
    String userPhone = '';
    String userFullname = '';
    postUserId = FirebaseAuth.instance.currentUser!.uid;
    if (_cityController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _building.text.isEmpty ||
        _floar.text.isEmpty ||
        _rooms.text.isEmpty ||
        _price.text.isEmpty ||
        _streetnController.text.isEmpty ||
        _expController.text.isEmpty) {
      print('Please fill in all the required fields.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the required fields.')),
      );
      return;
    }
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //User? user = FirebaseAuth.instance.currentUser;
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userEmail)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        userPhone = querySnapshot.docs[0].data()['phone'];
        userFullname = querySnapshot.docs[0].data()['username'];
        //print('User profile photo: $userProfilePhoto');
      } else {
        print('No user found with the email: $userEmail');
      }
      document = querySnapshot.docs[0].id.toString();
      print('\n\n\n This is my Document id: $document');

      for (File image in _images) {
        String downloadUrl = image.path;
        downloadUrls.add(downloadUrl);
      }
      QuerySnapshot<Map<String, dynamic>> snapshott =
          await FirebaseFirestore.instance.collection('apartments').get();
      k = snapshott.docs.length + 1;
      //k = totalCount;

      await firestore.collection('apartments').add({
        'email': userEmail,
        'phone': userPhone,
        'username': userFullname,
        'house': _selectedhouse.toString(),
        'district': _selectedstate.toString(),
        'city': _cityController.text,
        'street': _streetController.text,
        'building': _building.text,
        'floar': _floar.text,
        'rooms': _rooms.text,
        'price': _price.text,
        'streetNumber': _streetnController.text,
        'explain': _expController.text,
        'ExclusiveProperty': _isChecked1,
        'AirCondition': _isChecked2,
        'Bars': _isChecked3,
        'Heater': _isChecked4,
        'AccessForDisabled': _isChecked5,
        'Renovated': _isChecked6,
        'Shelter': _isChecked7,
        'Storage': _isChecked8,
        'Pets': _isChecked9,
        'Furniture': _isChecked10,
        'flexible': _isChecked11,
        'LongTerm': _isChecked12,
        'postedDate': DateFormat('dd/MM/yyyy').format(currentDate),
        'rating': 0.1,
        'raters': raters,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      });

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('apartments')
          .where('email', isEqualTo: userEmail)
          .where('phone', isEqualTo: userPhone)
          .where('username', isEqualTo: userFullname)
          .where('house', isEqualTo: _selectedhouse.toString())
          .where('district', isEqualTo: _selectedstate.toString())
          .where('city', isEqualTo: _cityController.text)
          .where('street', isEqualTo: _streetController.text)
          .where('building', isEqualTo: _building.text)
          .where('floar', isEqualTo: _floar.text)
          .where('rooms', isEqualTo: _rooms.text)
          .where('price', isEqualTo: _price.text)
          .where('streetNumber', isEqualTo: _streetnController.text)
          .where('explain', isEqualTo: _expController.text)
          .where('ExclusiveProperty', isEqualTo: _isChecked1)
          .where('AirCondition', isEqualTo: _isChecked2)
          .where('Bars', isEqualTo: _isChecked3)
          .where('Heater', isEqualTo: _isChecked4)
          .where('AccessForDisabled', isEqualTo: _isChecked5)
          .where('Renovated', isEqualTo: _isChecked6)
          .where('Shelter', isEqualTo: _isChecked7)
          .where('Storage', isEqualTo: _isChecked8)
          .where('Pets', isEqualTo: _isChecked9)
          .where('Furniture', isEqualTo: _isChecked10)
          .where('flexible', isEqualTo: _isChecked11)
          .where('LongTerm', isEqualTo: _isChecked12)
          .get();

      documents = snapshot.docs[0].id.toString();

      await _uploadImagesToFirebaseStorage();
      Navigator.of(context).pushReplacement(CustomPageRoute(
        pageBuilder: (context) => MyHouse(),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('81'.tr)),
        );
        print('81'.tr);
      }
    } catch (e) {
      print(e);
    }
  }

  void _addNotification() async {
    newnot = true;

    String userPhone = '';
    String userFullname = '';
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //User? user = FirebaseAuth.instance.currentUser;
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      QuerySnapshot<Map<String, dynamic>> querySnapshott =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userEmail)
              .get();
      if (querySnapshott.docs.isNotEmpty) {
        userPhone = querySnapshott.docs[0].data()['phone'];
        userFullname = querySnapshott.docs[0].data()['username'];
        //print('User profile photo: $userProfilePhoto');
      } else {
        print('No user found with the email: $userEmail');
      }
      // document = querySnapshott.docs[0].id.toString();

      QuerySnapshot<Map<String, dynamic>> snapshottt =
          await FirebaseFirestore.instance.collection('notifications').get();

      String message = "124".tr;

      print('\nNumber of documents: $k');
      await firestore.collection('notifications').add({
        'email': userEmail,
        'phone': userPhone,
        'msg': message,
        'time': DateFormat('HH:mm dd/MM/yyyy').format(currentDate),
      });

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('notifications')
          .where('email', isEqualTo: userEmail)
          .where('phone', isEqualTo: userPhone)
          .get();

      //documents = snapshot.docs[0].id.toString();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('81'.tr)),
        );
        print('81'.tr);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadImagesToFirebaseStorage() async {
    print('This is my best rrrdocument $documents');
    for (int i = 0; i < _images.length; i++) {
      try {
        File imageFile = _images[i];
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Create a reference to the location you want to upload to in Firebase Storage
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/$documents/$fileName.jpg');

        // Upload the file to Firebase Storage
        UploadTask uploadTask = storageReference.putFile(imageFile);

        // Wait for the upload task to complete and fetch the download URL
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Print the download URL for the uploaded image
        print('Download URL for Image $i: $k');
      } catch (error) {
        print('Error uploading image $i: $error');
      }
    }
  }

  Widget buildCheckboxItem(String title, bool value) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.start,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            setState(() {
              if (title == '88'.tr) _isChecked1 = newValue!;
              if (title == '89'.tr) _isChecked2 = newValue!;
              if (title == '90'.tr) _isChecked3 = newValue!;
              if (title == '91'.tr) _isChecked4 = newValue!;
              if (title == '92'.tr) _isChecked5 = newValue!;
              if (title == '93'.tr) _isChecked6 = newValue!;
              if (title == '94'.tr) _isChecked7 = newValue!;
              if (title == '95'.tr) _isChecked8 = newValue!;
              if (title == '96'.tr) _isChecked9 = newValue!;
              if (title == '97'.tr) _isChecked10 = newValue!;
              if (title == '98'.tr) _isChecked11 = newValue!;
              if (title == '99'.tr) _isChecked12 = newValue!;
            });
          },
        ),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(6, 0, 0, 1),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppBar(
                        backgroundColor: const Color.fromARGB(
                            0, 245, 4, 4), // Make app bar transparent
                        elevation: 0, // Remove app bar shadow
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        //  width: 150,
                                        //textDirection: TextDirection.rtl,
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: TextFormField(
                                            controller: _cityController,
                                            textAlign: TextAlign
                                                .left, // Align the label text to the right

                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(), // Default border sides
                                                ),
                                                labelText: '34'.tr,
                                                labelStyle: TextStyle(
                                                    color: Colors.black)),
                                            onSaved: (value) {
                                              _cityController = value
                                                  as TextEditingController;
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter ${'34'.tr}';
                                              }
                                              return null;
                                            },
                                            //validator: validatorForm,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        // textDirection: TextDirection.rtl,
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: TextFormField(
                                            controller: _streetController,
                                            textAlign: TextAlign
                                                .left, // Align the label text to the right
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(), // Default border sides
                                              ),
                                              labelText: '35'.tr,
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onSaved: (value) {
                                              _streetController = value
                                                  as TextEditingController;
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter ${'35'.tr}';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        //textDirection: TextDirection.rtl,
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: TextFormField(
                                            controller: _streetnController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(), // Default border sides
                                                ),
                                                labelText: '42'.tr,
                                                labelStyle: TextStyle(
                                                    color: Colors.black)),
                                            onSaved: (value) {
                                              _streetnController = value
                                                  as TextEditingController;
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter ${'42'.tr}';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: TextFormField(
                                            controller: _building,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(), // Default border sides
                                                ),
                                                labelText: '104'.tr,
                                                labelStyle: TextStyle(
                                                    color: Colors.black)),
                                            onSaved: (value) {
                                              _building = value
                                                  as TextEditingController;
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter ${'104'.tr}';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: TextFormField(
                                            controller: _rooms,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(), // Default border sides
                                                ),
                                                labelText: '31'.tr,
                                                labelStyle: TextStyle(
                                                    color: Colors.black)),
                                            onSaved: (value) {
                                              _rooms = value
                                                  as TextEditingController;
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter ${'31'.tr}';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: TextFormField(
                                            controller: _floar,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(), // Default border sides
                                                ),
                                                labelText: '109'.tr + ':',
                                                labelStyle: TextStyle(
                                                    color: Colors.black)),
                                            onSaved: (value) {
                                              _floar = value
                                                  as TextEditingController;
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter ${'109'.tr}';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        //textDirection: TextDirection.rtl,
                                        child: Container(
                                          // height: 70,
                                          // padding: EdgeInsets.only(bottom: 40),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            //   color: Color.fromARGB(
                                            //       179, 255, 255, 255),
                                          ),
                                          child: Container(
                                            height: 50,
                                            color: Colors.white,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _price,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(), // Default border sides
                                                ),
                                                labelText: '30'.tr,
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              onSaved: (value) {
                                                _price = value
                                                    as TextEditingController;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter ${'30'.tr}';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Color.fromARGB(179, 255, 255, 255),
                                    ),
                                    //textDirection: TextDirection.rtl,
                                    child: Container(
                                      color: Colors.white,
                                      child: TextFormField(
                                        maxLines: null,
                                        controller: _expController,
                                        textAlign: TextAlign
                                            .left, // Align the label text to the right
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(), // Default border sides
                                            ),
                                            labelText: '39'.tr,
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                        onSaved: (value) {
                                          _expController =
                                              value as TextEditingController;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter ${'39'.tr}';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          '40'.tr + ':',
                                          style: GoogleFonts.lato(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        padding:
                                            EdgeInsets.only(right: 5, left: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,

                                          border: Border.all(
                                              color: Colors
                                                  .grey), // Border on all sides
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Optional: rounded corners
                                        ),
                                        child: DropdownButton(
                                            underline: Container(
                                                color: const Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            value: _selectedhouse,
                                            items: Kind.values
                                                .map(
                                                  (lang) => DropdownMenuItem(
                                                    value: lang,
                                                    child: Text(
                                                      lang.kindValue.toString(),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              if (value == null) {
                                                return;
                                              }
                                              setState(() {
                                                _selectedhouse = value;
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          '41'.tr + ':',
                                          style: GoogleFonts.lato(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        padding:
                                            EdgeInsets.only(right: 5, left: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors
                                                  .grey), // Border on all sides
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Optional: rounded corners
                                        ),
                                        child: DropdownButton(
                                          underline: Container(
                                              color: const Color.fromARGB(
                                                  0, 255, 255, 255)),
                                          value: _selectedstate,
                                          items: States.values
                                              .map(
                                                (lang) => DropdownMenuItem(
                                                  value: lang,
                                                  child: Text(
                                                    lang.statesValue.toString(),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            if (value == null) {
                                              return;
                                            }
                                            setState(() {
                                              _selectedstate = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          //color: Colors.white,
                                          child: Column(
                                            children: [
                                              buildCheckboxItem(
                                                '88'.tr,
                                                _isChecked1,
                                              ),
                                              buildCheckboxItem(
                                                  '89'.tr, _isChecked2),
                                              buildCheckboxItem(
                                                  '90'.tr, _isChecked3),
                                              buildCheckboxItem(
                                                  '91'.tr, _isChecked4),
                                              buildCheckboxItem(
                                                  '92'.tr, _isChecked5),
                                              buildCheckboxItem(
                                                  '93'.tr, _isChecked6),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          //  color: Colors.white,
                                          child: Column(
                                            children: [
                                              // SizedBox(
                                              //   height: 18,
                                              // ),
                                              buildCheckboxItem(
                                                  '94'.tr, _isChecked7),
                                              buildCheckboxItem(
                                                  '95'.tr, _isChecked8),
                                              buildCheckboxItem(
                                                  '96'.tr, _isChecked9),
                                              buildCheckboxItem(
                                                  '97'.tr, _isChecked10),
                                              buildCheckboxItem(
                                                  '98'.tr, _isChecked11),
                                              buildCheckboxItem(
                                                  '99'.tr, _isChecked12),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          showImages = true;

                                          return Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading:
                                                      Icon(Icons.photo_library),
                                                  title: Text('60'.tr),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.gallery);

                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      Icon(Icons.camera_alt),
                                                  title: Text('61'.tr),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.camera);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      '100'.tr,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      // primary: Colors.teal,
                                      side: const BorderSide(
                                          color: Color.fromARGB(121, 0, 0, 0),
                                          width: 2.0),
                                      minimumSize: Size(40, 40),
                                    ),
                                  ),
                                  // SizedBox(height: 20),

                                  showImages
                                      ? Container(
                                          height: 100,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _images.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 90,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedImage =
                                                                index;
                                                            showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  AlertDialog(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                content: Image
                                                                    .file(_images[
                                                                        index]),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          showImages =
                                                                              true;

                                                                          return Container(
                                                                            padding:
                                                                                EdgeInsets.all(16),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                ListTile(
                                                                                  leading: Icon(Icons.photo_library),
                                                                                  title: Text('60'.tr),
                                                                                  onTap: () {
                                                                                    changeImage(ImageSource.gallery);

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                ListTile(
                                                                                  leading: Icon(Icons.camera_alt),
                                                                                  title: Text('61'.tr),
                                                                                  onTap: () {
                                                                                    changeImage(ImageSource.camera);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ); // או _pickImage(ImageSource.camera);
                                                                    },
                                                                    child: Text(
                                                                        '164'
                                                                            .tr),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        _images.removeAt(
                                                                            index);
                                                                        if (_images
                                                                            .isEmpty) {
                                                                          showImages =
                                                                              false;
                                                                        }
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        '105'
                                                                            .tr),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                        },
                                                        child: Image.file(
                                                          _images[index],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    if (selectedImage == index)
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: CircleAvatar(
                                                          // backgroundColor:
                                                          //     Colors.red,
                                                          radius: 10,
                                                          child: Icon(
                                                            Icons.cancel,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 255, 0, 0),
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Color.fromARGB(121, 0, 0, 0),
                                    width: 2.0),
                              ),
                              color: Color.fromARGB(255, 255, 255, 255),
                              colorBrightness: Brightness.dark,
                              onPressed: () {
                                _add();
                                _addNotification();
                              }, //_add, //() {

                              child: Text(
                                '87'.tr,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
