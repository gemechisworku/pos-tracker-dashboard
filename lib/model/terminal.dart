import 'package:cloud_firestore/cloud_firestore.dart';

class Terminal {
  final String branchId;
  final String branchName;
  final String district;
  final String? latitude;
  final String? longitude;
  final String merchId;
  final String merchName;
  final String termId;
  final String termName;
  final String dateCreated;
  final String dateArchived;

  Terminal({
    required this.branchId,
    required this.branchName,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.merchId,
    required this.merchName,
    required this.termId,
    required this.termName,
    required this.dateCreated,
    required this.dateArchived,}
  );
factory Terminal.fromDocumentSnapshot({required DocumentSnapshot<Map<String,dynamic>> doc}){
    return Terminal(
        branchId: doc.data()!['branch-id'],
        branchName: doc.data()!['branch-name'],
        district: doc.data()!['district'],
        latitude: doc.data()!['latitude'].toString(),
        longitude: doc.data()!['longitude'].toString(),
        merchId: doc.data()!['merch-id'],
        merchName: doc.data()!['merch-name'],
        termId: doc.data()!['term-id'],
        termName: doc.data()!['term-name'],
        dateCreated: doc.data()!['date-created'],
        dateArchived: doc.data()!['date-archived'],
    );
}

  Map<String, dynamic> toFirestore() {
    return {
      'branch-id': branchId,
      'branch-name': branchName,
      'district': district,
      'latitude': latitude,
      'langitude': longitude,
      'merch-id': merchId,
      'merch-name': merchName,
      'term-id': termId,
      'term-name': termName,
      'date-created': dateCreated,
      'date-archived': dateArchived,
    };
  }

  Terminal.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : branchId = snapshot.data()?['branch-id'],
        branchName = snapshot.data()?['branch-name'],
        district = snapshot.data()?['district'],
        latitude = snapshot.data()?['latitude'].toString(),
        longitude = snapshot.data()?['longitude'].toString(),
        merchId = snapshot.data()?['merch-id'],
        merchName = snapshot.data()?['merch-name'],
        termId = snapshot.data()?['term-id'],
        termName = snapshot.data()?['term-name'],
        dateCreated = snapshot.data()?['date-created'],
        dateArchived = snapshot.data()?['date-archived'];
}
