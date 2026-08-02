// ignore_for_file: unused_element, unused_field, unused_import, deprecated_member_use

import 'dart:io';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/HouseRent/ApartmentIcons.dart';
import 'package:derot/HouseRent/HouseEditor/myHouses.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditHouse extends StatefulWidget {
  final String documentId;

  EditHouse({required this.documentId});

  @override
  _EditHouse createState() => _EditHouse();
}

class _EditHouse extends State<EditHouse> {
  static const Color _accent = Color(0xFF0D47A1);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  Kind _selectedhouse = Kind.partners;
  States _selectedstate = States.center;
  Map<String, dynamic> apartmentData = {};
  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  bool showImages = false;

  @override
  void initState() {
    super.initState();
    _fetchApartmentData();
    _fetchExistingImages();
  }

  Future<void> _fetchApartmentData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('apartments').doc(widget.documentId).get();

      if (snapshot.exists) {
        setState(() {
          apartmentData = snapshot.data()!;
        });
      } else {
        print('No matching apartment found with ID: ${widget.documentId}');
      }
    } catch (e) {
      print('Error fetching apartment data: $e');
    }
  }

  Future<void> _fetchExistingImages() async {
    try {
      final ListResult result =
          await storage.ref('images/${widget.documentId}/').listAll();
      List<String> urls = await Future.wait(
          result.items.map((item) => item.getDownloadURL()).toList());
      setState(() {
        _existingImageUrls = urls;
      });
    } catch (e) {
      print('Error fetching existing images: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _newImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _uploadImages() async {
    for (File image in _newImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask uploadTask =
          storage.ref('images/${widget.documentId}/$fileName').putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      _existingImageUrls.add(downloadUrl);
    }
  }

  Future<void> _deleteImage(String url) async {
    try {
      final ref = await storage.refFromURL(url);
      await ref.delete();
      setState(() {
        _existingImageUrls.remove(url);
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> _updateApartmentData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final userEmail = auth.currentUser?.email;
        if (userEmail == null) {
          print('User is not logged in');
          return;
        }

        QuerySnapshot<Map<String, dynamic>> userSnapshot = await firestore
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();
        DocumentSnapshot<Map<String, dynamic>> userSnapshottt = await firestore
            .collection('apartments')
            .doc(widget.documentId)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          String userPhone = userSnapshot.docs[0].data()['phone'];
          String userFullname = userSnapshot.docs[0].data()['username'];
          String rating = userSnapshottt.data()!['rating'].toString();

          await _uploadImages();

          await firestore
              .collection('apartments')
              .doc(widget.documentId)
              .update({
            'email': userEmail,
            'phone': userPhone,
            'username': userFullname,
            'rating': rating,
            ...apartmentData,
            'postedDate': DateFormat('dd/MM/yyyy').format(DateTime.now()),
          });

          Navigator.of(context).pushReplacement(CustomPageRoute(
            pageBuilder: (context) => MyHouse(),
          ));
        } else {
          print('No user found with the email: $userEmail');
        }
      } catch (e) {
        print('Error updating apartment data: $e');
      }
    }
  }

  Widget _buildTextField(String key, String label, String initialValue,
      {TextInputType? keyboardType}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          labelText: label,
          labelStyle:
              TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600),
        ),
        onSaved: (value) {
          apartmentData[key] = value;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "${'216'.tr} $label";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumberTextField(String key, String label, String initialValue) {
    return _buildTextField(key, label, initialValue,
        keyboardType: TextInputType.number);
  }

  Widget _buildToggleChip(String key, String label, bool initialValue) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool value = apartmentData[key] ?? initialValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          apartmentData[key] = !value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: value
              ? _accent
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value
                ? _accent
                : (isDark ? Colors.white24 : Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle : Icons.add_circle_outline,
              size: 16,
              color: value
                  ? Colors.white
                  : (isDark ? Colors.white54 : Colors.grey.shade500),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: value
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text('103'.tr),
        centerTitle: true,
      ),
      body: apartmentData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isDark
                        ? null
                        : [
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
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                  'city', '34'.tr, apartmentData['city']),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildTextField(
                                  'street', '35'.tr, apartmentData['street']),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField('building', '104'.tr,
                                  apartmentData['building']),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildNumberTextField(
                                  'floar', '109'.tr, apartmentData['floar']),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildNumberTextField(
                                  'rooms', '31'.tr, apartmentData['rooms']),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildNumberTextField(
                                  'price', '30'.tr, apartmentData['price']),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildNumberTextField('streetNumber',
                                  '42'.tr, apartmentData['streetNumber']),
                            ),
                          ],
                        ),
                        _buildTextField(
                            'explain', '39'.tr, apartmentData['explain']),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildToggleChip('ExclusiveProperty', '88'.tr,
                                apartmentData['ExclusiveProperty'] == true),
                            _buildToggleChip('AirCondition', '102'.tr,
                                apartmentData['AirCondition'] == true),
                            _buildToggleChip(
                                'Bars', '90'.tr, apartmentData['Bars'] == true),
                            _buildToggleChip('Heater', '91'.tr,
                                apartmentData['Heater'] == true),
                            _buildToggleChip('AccessForDisabled', '92'.tr,
                                apartmentData['AccessForDisabled'] == true),
                            _buildToggleChip('Renovated', '93'.tr,
                                apartmentData['Renovated'] == true),
                            _buildToggleChip('Shelter', '94'.tr,
                                apartmentData['Shelter'] == true),
                            _buildToggleChip('Storage', '95'.tr,
                                apartmentData['Storage'] == true),
                            _buildToggleChip(
                                'Pets', '96'.tr, apartmentData['Pets'] == true),
                            _buildToggleChip('Furniture', '97'.tr,
                                apartmentData['Furniture'] == true),
                            _buildToggleChip('flexible', '98'.tr,
                                apartmentData['flexible'] == true),
                            _buildToggleChip('LongTerm', '99'.tr,
                                apartmentData['LongTerm'] == true),
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
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                            Icons.photo_library),
                                        title: Text('60'.tr),
                                        onTap: () {
                                          _pickImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.camera_alt),
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
                              color: _accent),
                          label: Text(
                            '100'.tr,
                            style: const TextStyle(
                                color: _accent,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            side: const BorderSide(color: _accent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        if (_existingImageUrls.isNotEmpty ||
                            _newImages.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ..._existingImageUrls.map((url) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Image.network(url,
                                              fit: BoxFit.contain),
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        child: Image.network(url,
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover),
                                      ),
                                      Positioned(
                                        right: -6,
                                        top: -6,
                                        child: GestureDetector(
                                          onTap: () => _deleteImage(url),
                                          child: const CircleAvatar(
                                            radius: 11,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.close,
                                                size: 14,
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              ..._newImages.map((image) => GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Image.file(image,
                                                fit: BoxFit.contain),
                                          );
                                        },
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(image,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover),
                                    ),
                                  )),
                            ],
                          ),
                        ],
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
                                onTap: _updateApartmentData,
                                child: Center(
                                  child: Text(
                                    '103'.tr,
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
