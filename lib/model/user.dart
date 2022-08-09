import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String username;
  final String userType;
  final String district;
  final String branch;

  MyUser(
    this.username,
    this.userType,
    this.district,
    this.branch,
  );

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'user-type': userType,
      'district': district,
      'branch': branch,
    };
  }

  MyUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : branch = snapshot.data()?['branch'],
        username = snapshot.data()?['username'],
        district = snapshot.data()?['district'],
        userType = snapshot.data()?['user-type'];
}
