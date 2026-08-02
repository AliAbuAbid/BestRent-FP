import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File> downloadImage(String imageName) async {
    try {
      final ref = _storage.ref().child(imageName);
      final bytes = await ref.getData();
      final file = File(imageName);
      await file.writeAsBytes(bytes!);
      return file;
    } catch (e) {
      print('Error downloading image: $e');
      throw e;
    }
  }
}
