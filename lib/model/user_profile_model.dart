import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? gender;
  final int? age;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final double? tdee;
  final double? bmi;
  final String? profilePictureUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    this.uid,
    this.displayName,
    this.email,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.tdee,
    this.bmi,
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
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
        // Fetch the document data and create a UserProfile object
        return UserProfile(
          uid: uid,
          displayName: doc['displayName'] ?? 'No Name',
          email: doc['email'] ?? 'No Email',
          gender: doc['gender'] ?? 'No Gender',
          age: doc['age'] ?? 0,
          weight: doc['weight']?.toDouble() ?? 0.0,
          height: doc['height']?.toDouble() ?? 0.0,
          activityLevel: doc['activityLevel'] ?? 'No Activity Level',
          tdee: doc['tdee']?.toDouble() ?? 0.0,
          bmi: doc['bmi']?.toDouble() ?? 0.0,
          profilePictureUrl: doc['profilePictureUrl'] ?? 'No Profile Picture',
          createdAt: doc['createdAt']?.toDate() ?? DateTime.now(),
          updatedAt: doc['updatedAt']?.toDate() ?? DateTime.now(),
        );
      } else {
        // Handle if the profile doesn't exist
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }
}
