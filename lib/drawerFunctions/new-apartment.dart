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
        SnackBar(content: Text('209'.tr)),
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

      String message = "124";

      print('\nNumber of documents: $k');
      await firestore.collection('notifications').add({
        'email': userEmail,
        'phone': userPhone,
        'msgKey': message,
        'time': DateFormat('HH:mm dd/MM/yyyy').format(currentDate),
        'read': false,
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
    return GestureDetector(
      onTap: () {
        setState(() {
          if (title == '88'.tr) _isChecked1 = !_isChecked1;
          if (title == '89'.tr) _isChecked2 = !_isChecked2;
          if (title == '90'.tr) _isChecked3 = !_isChecked3;
          if (title == '91'.tr) _isChecked4 = !_isChecked4;
          if (title == '92'.tr) _isChecked5 = !_isChecked5;
          if (title == '93'.tr) _isChecked6 = !_isChecked6;
          if (title == '94'.tr) _isChecked7 = !_isChecked7;
          if (title == '95'.tr) _isChecked8 = !_isChecked8;
          if (title == '96'.tr) _isChecked9 = !_isChecked9;
          if (title == '97'.tr) _isChecked10 = !_isChecked10;
          if (title == '98'.tr) _isChecked11 = !_isChecked11;
          if (title == '99'.tr) _isChecked12 = !_isChecked12;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF0D47A1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value ? const Color(0xFF0D47A1) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle : Icons.add_circle_outline,
              size: 16,
              color: value ? Colors.white : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: value ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color.fromARGB(255, 45, 43, 43) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: isDark ? Color.fromARGB(255, 255, 255, 255) : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) label,
    required ValueChanged<T?> onChanged,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color.fromARGB(255, 40, 39, 39) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(99, 247, 247, 247)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(label(item)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 0, 0, 0)
          : const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text('8'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDark ? const Color.fromARGB(255, 30, 29, 29) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          controller: _cityController,
                          label: '34'.tr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildField(
                          controller: _streetController,
                          label: '35'.tr,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          controller: _streetnController,
                          label: '42'.tr,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildField(
                          controller: _building,
                          label: '104'.tr,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          controller: _rooms,
                          label: '31'.tr,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildField(
                          controller: _floar,
                          label: '109'.tr,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildField(
                          controller: _price,
                          label: '30'.tr,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    controller: _expController,
                    label: '39'.tr,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel('${'40'.tr}:'),
                  _buildDropdown<Kind>(
                    value: _selectedhouse,
                    items: Kind.values,
                    label: (k) => k.kindValue.toString(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedhouse = value;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildSectionLabel('${'41'.tr}:'),
                  _buildDropdown<States>(
                    value: _selectedstate,
                    items: States.values,
                    label: (s) => s.statesValue.toString(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedstate = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      buildCheckboxItem('88'.tr, _isChecked1),
                      buildCheckboxItem('89'.tr, _isChecked2),
                      buildCheckboxItem('90'.tr, _isChecked3),
                      buildCheckboxItem('91'.tr, _isChecked4),
                      buildCheckboxItem('92'.tr, _isChecked5),
                      buildCheckboxItem('93'.tr, _isChecked6),
                      buildCheckboxItem('94'.tr, _isChecked7),
                      buildCheckboxItem('95'.tr, _isChecked8),
                      buildCheckboxItem('96'.tr, _isChecked9),
                      buildCheckboxItem('97'.tr, _isChecked10),
                      buildCheckboxItem('98'.tr, _isChecked11),
                      buildCheckboxItem('99'.tr, _isChecked12),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
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
                                  leading: Icon(Icons.photo_library),
                                  title: Text('60'.tr),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);

                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.camera_alt),
                                  title: Text('61'.tr),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add_photo_alternate_outlined,
                        color: Color(0xFF0D47A1)),
                    label: Text(
                      '100'.tr,
                      style: const TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      side: const BorderSide(color: Color(0xFF0D47A1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  showImages
                      ? Container(
                          height: 100,
                          margin: const EdgeInsets.only(top: 14),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, right: 10),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 90,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedImage = index;
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                contentPadding: EdgeInsets.zero,
                                                content:
                                                    Image.file(_images[index]),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          showImages = true;

                                                          return Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .photo_library),
                                                                  title: Text(
                                                                      '60'.tr),
                                                                  onTap: () {
                                                                    changeImage(
                                                                        ImageSource
                                                                            .gallery);

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .camera_alt),
                                                                  title: Text(
                                                                      '61'.tr),
                                                                  onTap: () {
                                                                    changeImage(
                                                                        ImageSource
                                                                            .camera);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ); // או _pickImage(ImageSource.camera);
                                                    },
                                                    child: Text('164'.tr),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _images.removeAt(index);
                                                        if (_images.isEmpty) {
                                                          showImages = false;
                                                        }
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('105'.tr),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.file(
                                            _images[index],
                                            fit: BoxFit.cover,
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (selectedImage == index)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 10,
                                          child: Icon(
                                            Icons.cancel,
                                            color: const Color.fromARGB(
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
                      : const SizedBox.shrink(),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 46,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D47A1), Color(0xFF26C6DA)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            _add();
                            _addNotification();
                          },
                          child: Center(
                            child: Text(
                              '87'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
