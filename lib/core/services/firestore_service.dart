import 'dart:developer';

import 'package:check_in/core/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._internal();
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a new check-in point. If an existing one is found, it will be deleted first.
  Future<void> createCheckInPoint(Map<String, dynamic> data) async {
    final collection = firestore.collection('checkin_points');
    final existing = await collection.get();

    for (var doc in existing.docs) {
      await doc.reference.delete();
    }
    await collection.add(data);
  }

  // fetch all check-in points
  Future<List<Map<String, dynamic>>> fetchCheckInPoints() async {
    final snapshot = await firestore.collection('checkin_points').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // // fetch all check-in persons
  // Future<List<Map<String, dynamic>>> fetchCheckInActivePersons() async {
  //   final snapshot = await firestore.collection('checkin_users').where('status', isEqualTo: "active").get();
  //   return snapshot.docs.map((doc) => doc.data()).toList();
  // }

  Stream<List<Map<String, dynamic>>> activeUsersStream() {
    final collection = firestore.collection('checkin_users');

    // Listen for all users with active status
    return collection
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return data;
      }).toList();
    });
  }

  Future<void> checkInOut({
    required double lat,
    required double lng,
    required bool isCheckIn,
  }) async {
    final uid = FirebaseService().firebaseAuth.currentUser?.uid;
    if (uid == null) return;

    final collection = firestore.collection('checkin_users');

    // Check if user already exists
    final querySnapshot =
        await collection.where('uid', isEqualTo: uid).limit(10000).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Update existing document
      final docId = querySnapshot.docs.first.id;
      await collection.doc(docId).update({
        'latitude': lat,
        'longitude': lng,
        'status': isCheckIn ? 'active' : 'inactive',
      });
    } else {
      // Create new document
      await collection.add({
        'latitude': lat,
        'longitude': lng,
        'uid': uid,
        'status': isCheckIn ? 'active' : 'inactive',
      });
    }
  }

  Stream<bool> userCheckInStatusStream() {
    final uid = FirebaseService().firebaseAuth.currentUser?.uid;
    if (uid == null) {
      // return a stream that always emits false when user is not logged in
      return Stream.value(false);
    }

    final collection = firestore.collection('checkin_users');

    // Listen for realtime changes to the user’s check-in document
    return collection
        .where('uid', isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return data['status'] == 'active';
      }
      return false;
    });
  }
}
