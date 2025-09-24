import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Add user after email/password signup
  Future<void> addUserToFirestore(User user, String name, String phone) async {
    final docRef = _db.collection('users').doc(user.uid);

    // Check if user already exists
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'name': name,
        'email': user.email ?? '',
        'phone': phone,
        'profilePicUrl': '', // Optional
        'createdAt': FieldValue.serverTimestamp(),
        'sosContacts': [], // Initialize empty
        'locationSharing': true, // Default
      });
    }
  }

  /// Add user after Google Sign-In
  Future<void> addGoogleUserToFirestore(User user) async {
    final docRef = _db.collection('users').doc(user.uid);

    // Check if user already exists
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'name': user.displayName ?? 'No Name',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'profilePicUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'sosContacts': [],
        'locationSharing': true,
      });
    }
  }

  /// Update user's name (optional, if you allow edit later)
  Future<void> updateUserName(String uid, String newName) async {
    await _db.collection('users').doc(uid).update({'name': newName});
  }

  /// Add/Update SOS contact
  Future<void> addSosContact(
    String uid,
    String contactName,
    String contactPhone,
  ) async {
    await _db.collection('users').doc(uid).update({
      'sosContacts': FieldValue.arrayUnion([
        {'name': contactName, 'phone': contactPhone},
      ]),
    });
  }
}
