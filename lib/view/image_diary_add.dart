import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddImageScreen extends StatefulWidget {
  @override
  _AddImageScreenState createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Image'),
      ),
      body: Column(
        children: [
          _image == null
              ? Text('No image selected.')
              : Image.file(File(_image!.path)),
          TextField(
            controller: _captionController,
            decoration: InputDecoration(hintText: 'Enter a caption'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            child: Text('Pick Image from Gallery'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: Text('Take a Picture'),
          ),
          ElevatedButton(
            onPressed: () => _uploadImage(),
            child: Text('Add Image to Journal'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      }
    });
  }

  void _uploadImage() async {
    if (_image == null) return;

    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final String fileName =
        'user_images/$userId/${DateTime
        .now()
        .millisecondsSinceEpoch}_${_image!.name}';
    final File imageFile = File(_image!.path);

    try {
      await FirebaseStorage.instance.ref(fileName).putFile(imageFile);
      final imageUrl =
      await FirebaseStorage.instance.ref(fileName).getDownloadURL();

      await FirebaseFirestore.instance
          .collection('userImageEntries')
          .doc(userId)
          .collection('user_images')
          .add({
        'imageUrl': imageUrl,
        'caption': _captionController.text,
        'uploadDate': DateTime.now(),
      });

      setState(() {
        _image = null;
        _captionController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }
}