import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String gender;
  final int age;
  final double weight;
  final double height;
  final String activityLevel;
  final double tdee;
  final double bmi;
  final String profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.tdee,
    required this.bmi,
    required this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserProfiles')
          .doc(userProfile.uid)
          .set({
        'displayName': userProfile.displayName,
        'email': userProfile.email,
        'gender': userProfile.gender,
        'age': userProfile.age,
        'weight': userProfile.weight,
        'height': userProfile.height,
        'activityLevel': userProfile.activityLevel,
        'tdee': userProfile.tdee,
        'bmi': userProfile.bmi,
        'profilePictureUrl': userProfile.profilePictureUrl,
        'createdAt': userProfile.createdAt,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('UserProfiles')
          .doc(uid)
          .get();
      if (doc.exists) {
        return UserProfile(
          uid: uid,
          displayName: doc['displayName'],
          email: doc['email'],
          gender: doc['gender'],
          age: doc['age'],
          weight: doc['weight'],
          height: doc['height'],
          activityLevel: doc['activityLevel'],
          tdee: doc['tdee'],
          bmi: doc['bmi'],
          profilePictureUrl: doc['profilePictureUrl'],
          createdAt: doc['createdAt'].toDate(),
          updatedAt: doc['updatedAt'].toDate(),
        );
      } else {
        return null; // Handle if the profile doesn't exist
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }
}
