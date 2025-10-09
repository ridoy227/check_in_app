import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._internal();
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // create check-in point
  Future<void> createCheckInPoint(Map<String, dynamic> data) async {
    await firestore.collection('checkin_points').add(data);
  }

  // fetch all check-in points
  Future<List<Map<String, dynamic>>> fetchCheckInPoints() async {
    final snapshot = await firestore.collection('checkin_points').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

}
