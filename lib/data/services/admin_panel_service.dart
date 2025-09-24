import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class AdminPanelService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send emergency alert to police admin panel
  static Future<bool> sendEmergencyAlertToPolice({
    required Position position,
    required String locationString,
    required String googleMapsUrl,
    String? additionalInfo,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('User not authenticated');
        return false;
      }

      // Get user details
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();

      // Create emergency alert document
      final emergencyAlert = {
        'userId': user.uid,
        'userName': userData?['name'] ?? 'Unknown User',
        'userPhone': userData?['phone'] ?? 'Unknown',
        'userEmail': user.email ?? 'Unknown',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'locationString': locationString,
        'googleMapsUrl': googleMapsUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'active', // active, responded, resolved
        'priority': 'high',
        'additionalInfo': additionalInfo ?? '',
        'isPoliceNotified': true,
        'isContactsNotified': true,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Save to emergency alerts collection
      await _firestore.collection('emergency_alerts').add(emergencyAlert);

      // Also save to police notifications collection
      await _firestore.collection('police_notifications').add({
        'alertId': '', // Will be updated after creation
        'userId': user.uid,
        'userName': userData?['name'] ?? 'Unknown User',
        'userPhone': userData?['phone'] ?? 'Unknown',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'locationString': locationString,
        'googleMapsUrl': googleMapsUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending', // pending, acknowledged, dispatched, resolved
        'priority': 'high',
        'additionalInfo': additionalInfo ?? '',
        'createdAt': DateTime.now().toIso8601String(),
      });

      print('Emergency alert sent to police admin panel');
      return true;
    } catch (e) {
      print('Error sending emergency alert to police: $e');
      return false;
    }
  }

  // Get emergency alerts for police admin panel
  static Stream<List<Map<String, dynamic>>> getEmergencyAlerts() {
    return _firestore
        .collection('emergency_alerts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  // Update emergency alert status (for police admin panel)
  static Future<bool> updateAlertStatus(String alertId, String status) async {
    try {
      await _firestore.collection('emergency_alerts').doc(alertId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating alert status: $e');
      return false;
    }
  }

  // Get user's emergency history
  static Stream<List<Map<String, dynamic>>> getUserEmergencyHistory() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('emergency_alerts')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  // Send notification to police via SMS/WhatsApp (if needed)
  static Future<bool> sendPoliceNotification({
    required String locationString,
    required String googleMapsUrl,
    required String userName,
    required String userPhone,
  }) async {
    try {
      // This would integrate with police notification system
      // For now, we'll just log it
      print('Police notification sent:');
      print('Location: $locationString');
      print('Maps URL: $googleMapsUrl');
      print('User: $userName ($userPhone)');

      // In the future, this could send SMS to police hotline
      // or integrate with police dispatch system

      return true;
    } catch (e) {
      print('Error sending police notification: $e');
      return false;
    }
  }
}

