import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_tracker/model/district.dart';
import 'package:pos_tracker/model/terminal.dart';

class DatabaseServiceClass {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //   addTerminal(Terminal terminalData) async {
  //   await _db.collection("Employees").add(terminalData.toMap());
  // }

  //   updateTerminal(Terminal terminalData) async {
  //   await _db.collection("Employees").doc(terminalData.id).update(terminalData.toFirestore());
  // }

  Future<void> deleteTerminal(String documentId) async {
    await _db.collection("location").doc(documentId).delete();
  }

  Future<List<Terminal>> retrieveTerminals() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("location").get();
    return snapshot.docs
        .map((docSnapshot) => Terminal.fromDocumentSnapshot(doc: docSnapshot))
        .toList();
  }

  Future<List<Terminal>> retrieveArchivedTerminals() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("archives").get();
    return snapshot.docs
        .map((docSnapshot) => Terminal.fromDocumentSnapshot(doc: docSnapshot))
        .toList();
  }

  Future<List<Terminal>> retrieveDistricts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("district-collection").get();
    return snapshot.docs
        .map((docSnapshot) => Terminal.fromDocumentSnapshot(doc: docSnapshot))
        .toList();
  }

  Future<List<String>> readDistricts() async {
    final districts = FirebaseFirestore.instance
        .collection('district-collection')
        .doc('district-document')
        .withConverter(
            fromFirestore: District.fromFirestore,
            toFirestore: (District district, _) => district.toFirestore());

    final docSnapshot = await districts.get();
    final dicList = docSnapshot.data()!.districts!;

    return dicList;
  }
}
