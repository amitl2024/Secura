import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/emergency_contact.dart';

class EmergencyContactService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static const String _collectionName = 'users';
  static const String _subCollectionName = 'emergencyContacts';

  // Get current user ID
  static String? get _currentUserId => _auth.currentUser?.uid;

  // Get emergency contacts for current user
  static Stream<List<EmergencyContact>> getEmergencyContacts() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collectionName)
        .doc(_currentUserId)
        .collection(_subCollectionName)
        .orderBy('isPrimary', descending: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return EmergencyContact.fromMap(data);
      }).toList();
    });
  }

  // Add new emergency contact
  static Future<String> addEmergencyContact(EmergencyContact contact) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    // Check if we already have 5 contacts
    final currentContacts = await _firestore
        .collection(_collectionName)
        .doc(_currentUserId)
        .collection(_subCollectionName)
        .get();

    if (currentContacts.docs.length >= 5) {
      throw Exception('Maximum 5 emergency contacts allowed');
    }

    // If this is the first contact or user wants to make it primary, set as primary
    if (currentContacts.docs.isEmpty || contact.isPrimary) {
      // Remove primary status from other contacts if this one is primary
      if (contact.isPrimary) {
        await _removePrimaryFromOtherContacts();
      }
    }

    final docRef = await _firestore
        .collection(_collectionName)
        .doc(_currentUserId)
        .collection(_subCollectionName)
        .add(contact.toMap());

    return docRef.id;
  }

  // Update emergency contact
  static Future<void> updateEmergencyContact(String contactId, EmergencyContact contact) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    // If making this contact primary, remove primary status from others
    if (contact.isPrimary) {
      await _removePrimaryFromOtherContacts();
    }

    await _firestore
        .collection(_collectionName)
        .doc(_currentUserId)
        .collection(_subCollectionName)
        .doc(contactId)
        .update(contact.toMap());
  }

  // Delete emergency contact
  static Future<void> deleteEmergencyContact(String contactId) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection(_collectionName)
        .doc(_currentUserId)
        .collection(_subCollectionName)
        .doc(contactId)
        .delete();
  }

  // Set contact as primary
  static Future<void> setPrimaryContact(String contactId) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    // Remove primary status from all contacts
    await _removePrimaryFromOtherContacts();

    // Set this contact as primary
    await _firestore
        .collection(_collectionName)
        .doc(_currentUserId)
        .collection(_subCollectionName)
        .doc(contactId)
        .update({'isPrimary': true});
  }

  // Remove primary status from all contacts except the specified one
  static Future<void> _removePrimaryFromOtherContacts({String? exceptContactId}) async {
    if (_currentUserId == null) return;

    final batch = _firestore.batch();
    final contactsSnapshot = await _firestore
        .collection(_collectionName)
        .doc(_currentUserId)
        .collection(_subCollectionName)
        .where('isPrimary', isEqualTo: true)
        .get();

    for (final doc in contactsSnapshot.docs) {
      if (exceptContactId == null || doc.id != exceptContactId) {
        batch.update(doc.reference, {'isPrimary': false});
      }
    }

    await batch.commit();
  }

  // Get primary contact
  static Future<EmergencyContact?> getPrimaryContact() async {
    if (_currentUserId == null) return null;

    final snapshot = await _firestore
        .collection(_collectionName)
        .doc(_currentUserId)
        .collection(_subCollectionName)
        .where('isPrimary', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      data['id'] = snapshot.docs.first.id;
      return EmergencyContact.fromMap(data);
    }

    return null;
  }

  // Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    // Check if it's between 10-15 digits (international format)
    return cleaned.length >= 10 && cleaned.length <= 15;
  }

  // Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.length == 10) {
      // US format: (XXX) XXX-XXXX
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    } else if (cleaned.length == 11 && cleaned.startsWith('1')) {
      // US format with country code: +1 (XXX) XXX-XXXX
      return '+1 (${cleaned.substring(1, 4)}) ${cleaned.substring(4, 7)}-${cleaned.substring(7)}';
    } else {
      // International format: +XX XXX XXX XXXX
      return '+$cleaned';
    }
  }
}

