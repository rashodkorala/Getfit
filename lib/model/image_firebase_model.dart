import 'package:cloud_firestore/cloud_firestore.dart';

class UserImageEntry {
  final String imageUrl;
  final String caption;
  final DateTime date;
  final String
      userId; // Optional, if you want to store which user uploaded the image

  UserImageEntry({
    required this.imageUrl,
    required this.caption,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'caption': caption,
      'date': date.toIso8601String(), // Storing date as a string
      'userId': userId,
    };
  }

  static UserImageEntry fromMap(Map<String, dynamic> map) {
    return UserImageEntry(
      imageUrl: map['imageUrl'],
      caption: map['caption'],
      date: DateTime.parse(map['date']),
      userId: map['userId'],
    );
  }
}
