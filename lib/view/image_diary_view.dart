import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageDiaryView extends StatefulWidget {
  final User? currentUser;

  ImageDiaryView({Key? key, this.currentUser}) : super(key: key);

  @override
  _ImageDiaryViewState createState() => _ImageDiaryViewState(currentUser);
}

class _ImageDiaryViewState extends State<ImageDiaryView> {
  final User? currentUser;

  _ImageDiaryViewState(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Diary'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user_images')
            .doc(currentUser!.uid)
            .collection('images')
            .orderBy('uploadDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No images found.'));
          }

          var imageEntries = snapshot.data!.docs;

          return ListView.builder(
            itemCount: imageEntries.length,
            itemBuilder: (context, index) {
              var entry = imageEntries[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(entry['imageUrl'],
                    width: 100, height: 100, fit: BoxFit.cover),
                title: Text(entry['caption']),
                subtitle: Text((entry['uploadDate'] as Timestamp)
                    .toDate()
                    .toIso8601String()),
              );
            },
          );
        },
      ),
    );
  }
}
