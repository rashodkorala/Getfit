import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/image_firebase_model.dart';

class FirestoreImageEntryService {
  final user = FirebaseAuth.instance.currentUser;

  final CollectionReference imageEntriesCollection;

  FirestoreImageEntryService()
      : imageEntriesCollection = FirebaseFirestore.instance
            .collection('user_images')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userImageEntries');

  Future<DocumentReference<Object?>> addImageEntry(
      UserImageEntry imageEntry) async {
    return await imageEntriesCollection.add(imageEntry.toMap());
  }

  Future<List<UserImageEntry>> getAllImageEntries() async {
    QuerySnapshot snapshot = await imageEntriesCollection.get();
    return snapshot.docs
        .map(
            (doc) => UserImageEntry.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateImageEntry(UserImageEntry imageEntry) async {
    return await imageEntriesCollection
        .doc(imageEntry.imageUrl)
        .update(imageEntry.toMap());
  }

  Future<void> deleteImageEntry(UserImageEntry imageEntry) async {
    return await imageEntriesCollection.doc(imageEntry.imageUrl).delete();
  }
}
