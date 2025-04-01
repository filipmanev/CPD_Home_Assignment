import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'winners_page.dart';

class UploadPicturePage extends StatefulWidget {
  final String userName;
  const UploadPicturePage({super.key, required this.userName});

  @override
  _UploadPicturePageState createState() => _UploadPicturePageState();
}

class _UploadPicturePageState extends State<UploadPicturePage> {
  File? _imageFile;
  bool _uploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> testFirebaseUpload(File imageFile) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(
            'test/$fileName',
          );
      UploadTask uploadTask = storageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          double progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          print("Upload progress: ${progress.toStringAsFixed(2)}%");
        },
        onError: (error) {
          print("Upload error during progress: $error");
        },
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Upload complete. URL: $downloadUrl");
    } catch (e, s) {
      print("Error during test upload: $e");
      print("Stack trace: $s");
    }
  }

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

    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(
            'winners/$fileName',
          );

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      UploadTask uploadTask = storageRef.putFile(_imageFile!, metadata);

      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          double progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          print("Upload progress: ${progress.toStringAsFixed(2)}%");
        },
        onError: (error) {
          print("Upload error during progress: $error");
        },
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Upload complete. File URL: $downloadUrl");

      await FirebaseFirestore.instance.collection('winners').add({
        'name': widget.userName,
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WinnersPage()),
      );
    } catch (e, s) {
      print("Error during upload: $e");
      print("Stack trace: $s");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Winner Picture')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Congrats ${widget.userName}! You got all questions right.',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _imageFile != null
                ? Image.file(_imageFile!, height: 300)
                : const Placeholder(fallbackHeight: 300),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  child: const Text('Take Picture'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pickFromGallery,
                  child: const Text('Choose from Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _uploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadPicture,
                    child: const Text('Upload Picture'),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
