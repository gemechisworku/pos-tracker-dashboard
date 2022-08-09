import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');

  Future updateUser(username, district, branch, userType) async {
    return await _collectionReference.doc(uid).set({
      'username': username,
      'district': district,
      'user-type': userType,
      'branch': branch,
    });
  }
}
