import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'image_diary_add.dart';

class ImageDiaryView extends StatefulWidget {
  @override
  _ImageDiaryViewState createState() => _ImageDiaryViewState();
}

class _ImageDiaryViewState extends State<ImageDiaryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Diary'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user_images')
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

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: imageEntries.length,
            itemBuilder: (context, index) {
              var entry = imageEntries[index].data() as Map<String, dynamic>;
              return GridTile(
                child: Image.network(entry['imageUrl'], fit: BoxFit.cover),
                footer: GridTileBar(
                  backgroundColor: Colors.black45,
                  title: Text(entry['caption']),
                  subtitle: Text(DateFormat.yMMMd()
                      .format((entry['uploadDate'] as Timestamp).toDate())),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddImageScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Photo',
      ),
    );
  }
}
