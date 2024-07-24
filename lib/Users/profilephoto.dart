// ignore_for_file: unused_import, unnecessary_import, unnecessary_cast, unused_local_variable, unused_element

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePhoto();
  }
}

bool tapped = false;
File? _image;
File? ig;

class _ProfilePhoto extends State<ProfilePhoto> {
  void _submit() {
    //final isValid = _form.currentState!.validate();
  }

  Future<void> _pickImage(ImageSource source) async {
    // TookImage();
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (_image != null) {
      setState(() {
        _image;
        tapped = true;
      });
    } else if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        path = pickedFile.path as String;
        tapped = true;
        updateUser();
      });
    }
  }

  String? img;
  void loadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    final storageRef =
        FirebaseStorage.instance.ref().child('user_images/${user!.uid}.jpg');

    try {
      // Get the download URL for the image
      final imageUrl = await storageRef.getDownloadURL();
      img = imageUrl;
      ig = _image;
      // Update the state to display the image
      setState(() {
        _image = File(imageUrl);
      });
    } catch (e) {
      _image = null;
      print('Error loading image from Firebase Storage: $e');
    }
  }

  Future<void> deleteImage() async {
    tapped = false;

    try {
      // Create a reference to the file to delete
      final user = FirebaseAuth.instance.currentUser;
      Reference storageRef =
          FirebaseStorage.instance.ref().child('user_images/${user!.uid}.jpg');

      // Delete the file
      await storageRef.delete();

      print('Image deleted successfully');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late String path;

  

  Future<void> updateUser() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    final user = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${user!.uid}.jpg');
    final imageUrl = await storageRef.putFile(_image!);
    storageRef.getDownloadURL();
    print(imageUrl);
    // await user?.updatePhotoURL(path);
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
  }

  Future<void> _showImagePickerOptionsf(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('delet photo'.tr),
                onTap: () {
                  deleteImage();
                  setState(() {
                    _image = null;
                    _buildImage();
                    path = 'There is no  photo';
                    //  _buildImage();
                    //TookImage();
                    //updateUser();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _buildImage() {
    var x = loadImage();
    if (_image != null && img != null) {
      print('The type of img:$img');
      tapped = true;

      // print('This is my best image $_image');

      return ClipOval(
          child: Image.network(
        img!,
        width: 130,
        height: 150,
        fit: BoxFit.cover,
      ));
    } else if (_image != null && img == null) {
      loadImage();

      return ClipOval(
        child: Image.file(
          _image!,
          width: 130,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    } else {
      tapped = false;
      return Icon(
        Icons.add_a_photo,
        size: 50,
        color: Color.fromARGB(255, 0, 0, 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (tapped == false) {
              _showImagePickerOptions(context);
            }
          },
          onLongPress: () {
            if (tapped == true) {
              _showImagePickerOptionsf(context);
            }
          },
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Color.fromARGB(74, 220, 228, 236),
            child: _buildImage(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
       
      ],
    );
  }
}
