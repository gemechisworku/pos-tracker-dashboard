import 'package:cloud_firestore/cloud_firestore.dart';

class District {
  final List<String>? districts;

  District({
    this.districts,
  });

  Map<String, dynamic> toFirestore() {
    return {if (districts != null) 'districts': districts};
  }

  factory District.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return District(
      districts:
          data?['districts'] is Iterable ? List.from(data?['districts']) : null,
    );
  }
}
