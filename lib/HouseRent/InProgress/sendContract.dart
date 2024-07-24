import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class UploadPdfPage extends StatefulWidget {
  final String docId;
  UploadPdfPage({
    super.key,
    required this.docId,
  });
  @override
  _UploadPdfPageState createState() => _UploadPdfPageState();
}

class _UploadPdfPageState extends State<UploadPdfPage> {
  bool _isUploading = false;
  String? _uploadedFileURL;
  String? _documentId;



  Future<void> _uploadPdf() async {
    _documentId = widget.docId;
    setState(() {
      _isUploading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      try {
        //String fileName = result.files.single.name;
        final destination = 'pdfs/$_documentId/$_documentId.pdf';

        final ref = FirebaseStorage.instance.ref(destination);
        final task = ref.putFile(file);

        final snapshot = await task.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        print('llllllllllllllllllllllllll $urlDownload');
        try {
          await FirebaseFirestore.instance
              .collection('inProgress')
              .doc(widget.docId)
              .update({
            'url': urlDownload,


          });
          print('Field added successfully');
        } catch (e) {
          print('Error adding field: $e');
        }

        setState(() {
          _uploadedFileURL = urlDownload;
        });
      } catch (e) {
        print('Error occurred while uploading: $e');
      }
    }

    Future<void> addFieldToDocument(String url) async {
      try {
        await FirebaseFirestore.instance
            .collection('inProgress')
            .doc(widget.docId)
            .update({
          'url': url,
        });
        print('Field added successfully');
      } catch (e) {
        print('Error adding field: $e');
      }
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: _isUploading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _uploadPdf,
                    child: Text('Select and Upload PDF'),
                  ),
                  SizedBox(height: 20),
                  _uploadedFileURL != null ? Text('') : Container(),
                ],
              ),
      ),
    );
  }
}
