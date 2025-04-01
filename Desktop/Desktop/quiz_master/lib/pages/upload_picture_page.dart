import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'winners_page.dart';

class UploadPicturePage extends StatefulWidget {
  final String userName;
  UploadPicturePage({required this.userName});

  @override
  _UploadPicturePageState createState() => _UploadPicturePageState();
}

class _UploadPicturePageState extends State<UploadPicturePage> {
  File? _imageFile;
  bool _uploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPicture() async {
    if (_imageFile == null) return;

    setState(() {
      _uploading = true;
    });


    //bruh
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('winners/$fileName');

      UploadTask uploadTask = storageRef.putFile(_imageFile!);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print("Upload progress: ${progress.toStringAsFixed(2)}%");
      }, onError: (error) {
        print("Upload error: $error");
      });

      //upload bs
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('winners').add({
        'name': widget.userName,
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WinnersPage()),
      );
    } catch (e) {
      print("Error during upload: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Winner Picture'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Congrats ${widget.userName}! You got all questions right.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 300,
                  )
                : Placeholder(
                    fallbackHeight: 300,
                  ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  child: Text('Take Picture'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pickFromGallery,
                  child: Text('Choose from Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            _uploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadPicture,
                    child: Text('Upload Picture'),
                  ),
          ],
        ),
      ),
    );
  }
}
