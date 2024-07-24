// ignore_for_file: unused_element, unused_field, unused_import

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
          // _selectedhouse = apartmentData['house'];
          // _selectedstate = apartmentData['district'];
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
          print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh $rating lllll');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // title: Text('103'.tr),
      //     ),
      body: apartmentData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0).withOpacity(
                    0.5), // Remove 'const' as 'withOpacity' creates a non-constant value
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/houses.jpg',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black
                        .withOpacity(0.2), // Apply opacity using ColorFilter
                    BlendMode.dstATop,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: const Color.fromARGB(
                          0, 245, 4, 4), // Make app bar transparent
                      elevation: 0, // Remove app bar shadow
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     //padding: EdgeInsets.only(left: 120),
                    //     //SizedBox(width: 10),
                    //     Text(
                    //       '40'.tr,
                    //       style: GoogleFonts.lato(
                    //           color: Color.fromARGB(255, 0, 0, 0),
                    //           fontSize: 19,
                    //           fontWeight: FontWeight.bold),
                    //       textAlign: TextAlign.center,
                    //     ),
                    // Spacer(),
                    //     SizedBox(height: 10),
                    //     DropdownButton(
                    //         value: _selectedhouse,
                    //         items: Kind.values
                    //             .map(
                    //               (lang) => DropdownMenuItem(
                    //                 value: lang,
                    //                 child: Text(
                    //                   lang.kindValue.toString(),
                    //                 ),
                    //               ),
                    //             )
                    //             .toList(),
                    //         onChanged: (value) {
                    //           if (value == null) {
                    //             return;
                    //           }

                    //           setState(() {
                    //             _selectedhouse = value;
                    //             // String originalString =
                    //             //     _selectedhouse.toString();
                    //             // List<String> parts = originalString.split('.');
                    //             // String houseKind = parts[1];
                    //             // _dropDownHouse('house', houseKind);
                    //           });
                    //         }),
                    //   ],
                    // ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     SizedBox(height: 32),
                    //     //padding: EdgeInsets.only(left: 120),
                    //     Text(
                    //       '41'.tr,
                    //       style: GoogleFonts.lato(
                    //           color: Color.fromARGB(255, 0, 0, 0),
                    //           fontSize: 19,
                    //           fontWeight: FontWeight.bold),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //     SizedBox(height: 10),
                    //     DropdownButton(
                    //         value: _selectedstate,
                    //         items: States.values
                    //             .map(
                    //               (lang) => DropdownMenuItem(
                    //                 value: lang,
                    //                 child: Text(
                    //                   lang.statesValue.toString(),
                    //                 ),
                    //               ),
                    //             )
                    //             .toList(),
                    //         onChanged: (value) {
                    //           if (value == null) {
                    //             return;
                    //           }
                    //           setState(() {
                    //             _selectedstate = value;
                    //             // String originalString =
                    //             //     _selectedstate.toString();
                    //             // List<String> parts = originalString.split('.');
                    //             // String districts = parts[1];
                    //             // _dropDownState('district', districts);
                    //           });
                    //         }),
                    //     SizedBox(height: 10),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              'city', '34'.tr, apartmentData['city']),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: _buildTextField(
                              'street', '35'.tr, apartmentData['street']),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              'building', '104'.tr, apartmentData['building']),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildNumberTextField(
                              'floar', '109'.tr, apartmentData['floar']),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberTextField(
                              'rooms', '31'.tr, apartmentData['rooms']),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildNumberTextField(
                              'price', '30'.tr, apartmentData['price']),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildNumberTextField('streetNumber', '42'.tr,
                              apartmentData['streetNumber']),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        'explain', '39'.tr, apartmentData['explain']),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                _buildCheckboxField(
                                    'ExclusiveProperty',
                                    '88'.tr,
                                    apartmentData['ExclusiveProperty']),
                                _buildCheckboxField('AirCondition', '102'.tr,
                                    apartmentData['AirCondition']),
                                _buildCheckboxField(
                                    'Bars', '90'.tr, apartmentData['Bars']),
                                _buildCheckboxField(
                                    'Heater', '91'.tr, apartmentData['Heater']),
                                _buildCheckboxField(
                                    'AccessForDisabled',
                                    '92'.tr,
                                    apartmentData['AccessForDisabled']),
                                _buildCheckboxField('Renovated', '93'.tr,
                                    apartmentData['Renovated']),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                _buildCheckboxField('Shelter', '94'.tr,
                                    apartmentData['Shelter']),
                                _buildCheckboxField('Storage', '95'.tr,
                                    apartmentData['Storage']),
                                _buildCheckboxField(
                                    'Pets', '96'.tr, apartmentData['Pets']),
                                _buildCheckboxField('Furniture', '97'.tr,
                                    apartmentData['Furniture']),
                                _buildCheckboxField('flexible', '98'.tr,
                                    apartmentData['flexible']),
                                _buildCheckboxField('LongTerm', '99'.tr,
                                    apartmentData['LongTerm']),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),
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
                      child: Text(
                        '100'.tr,
                      ),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: _existingImageUrls.map((url) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              Image.network(url, width: 100, height: 100),
                              Positioned(
                                right: -10,
                                top: -1,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteImage(url),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _newImages
                          .map((image) => GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Container(
                                          child: Image.file(
                                            image,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child:
                                    Image.file(image, width: 100, height: 100),
                              ))
                          .toList(),
                    ),
                    ElevatedButton(
                      onPressed: _updateApartmentData,
                      child: Text('103'.tr),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget _buildTextField(String key, String label, String initialValue) {
  //   return TextFormField(
  //     initialValue: initialValue,
  //     decoration: InputDecoration(labelText: label),
  //     onSaved: (value) {
  //       apartmentData[key] = value;
  //     },
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Please enter $label';
  //       }
  //       return null;
  //     },
  //   );
  // }

  Widget _buildTextField(String key, String label, String initialValue) {
    return Container(
      color: Colors.white,
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color.fromARGB(255, 0, 0, 0), width: 2.0),
          ),
        ),
        onSaved: (value) {
          apartmentData[key] = value;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Widget _buildTextNumberField(String key, String label, String initialValue) {
  //   return Container(
  //     color: Colors.white,
  //     child: TextFormField(
  //       keyboardType: TextInputType.number,
  //       initialValue: initialValue,
  //       decoration: InputDecoration(labelText: label),
  //       onSaved: (value) {
  //         apartmentData[key] = value;
  //       },
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Please enter $label';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }
  Widget _buildNumberTextField(String key, String label, String initialValue) {
    return Container(
      color: Colors.white,
      child: TextFormField(
        keyboardType: TextInputType.number,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color.fromARGB(255, 0, 0, 0), width: 2.0),
          ),
        ),
        onSaved: (value) {
          apartmentData[key] = value;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCheckboxField(String key, String label, bool initialValue) {
    return CheckboxListTile(
      title: Text(
        label,
        style: TextStyle(fontSize: 12),
      ),
      value: apartmentData[key] ?? initialValue,
      onChanged: (bool? value) {
        setState(() {
          apartmentData[key] = value;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  // void _dropDownHouse(String key, String value) {
  //   setState(() {
  //     apartmentData[key] = value;
  //   });
  // }

  // void _dropDownState(String key, String value) {
  //   setState(() {
  //     apartmentData[key] = value;
  //   });
  //}
}
