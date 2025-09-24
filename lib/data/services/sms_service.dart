import 'dart:async';
import 'package:telephony/telephony.dart';

final Telephony _telephony = Telephony.instance;

Future<bool> _ensureSmsPermissions() async {
  try {
    // Check if device is SMS capable
    final bool? hasSms = await _telephony.isSmsCapable;
    print("Device is SMS capable: $hasSms");
    if (hasSms != true) {
      print("❌ Device is not SMS capable");
      return false;
    }

    // Request SMS permissions directly through telephony plugin
    print("Requesting SMS permission...");
    final bool? granted = await _telephony.requestSmsPermissions;
    print("SMS permission granted: $granted");

    return granted ?? false;
  } catch (e) {
    print('Error checking SMS permissions: $e');
    return false;
  }
}

Future<bool> checkSmsPermissions() async {
  try {
    // Check if device is SMS capable
    final bool? hasSms = await _telephony.isSmsCapable;
    print("Device is SMS capable: $hasSms");
    if (hasSms != true) {
      print("❌ Device is not SMS capable");
      return false;
    }

    // Request SMS permissions directly through telephony plugin
    print("Requesting SMS permission...");
    final bool? granted = await _telephony.requestSmsPermissions;
    print("SMS permission granted: $granted");

    return granted ?? false;
  } catch (e) {
    print('Error checking SMS permissions: $e');
    return false;
  }
}

Future<void> sendAddContactSMS(String contactNumber, String userName) async {
  final ok = await _ensureSmsPermissions();
  if (!ok) {
    throw Exception('SMS permission not granted or device not SMS capable');
  }

  final String body =
      "Hello, $userName you have been added to my emergency contacts. "
      "In case of emergency, you will receive alerts and my location.";

  try {
    await _telephony.sendSms(to: contactNumber, message: body);
    print('SMS sent successfully to $contactNumber');
  } catch (e) {
    print('Error sending SMS: $e');
    rethrow;
  }
}

Future<void> sendEmergencyAlertSMS(
  String contactNumber,
  String userName,
  String locationString,
  String googleMapsUrl,
) async {
  print("🔧 Starting sendEmergencyAlertSMS function...");
  print("Contact: $contactNumber");
  print("User: $userName");

  try {
    // Check if device is SMS capable
    final bool? hasSms = await _telephony.isSmsCapable;
    print("Device is SMS capable: $hasSms");
    if (hasSms != true) {
      throw Exception('Device is not SMS capable');
    }

    // Request SMS permissions
    final bool? smsGranted = await _telephony.requestSmsPermissions;
    print("SMS permission granted: $smsGranted");
    if (smsGranted != true) {
      throw Exception('SMS permission not granted');
    }

    final String body =
        "🚨 EMERGENCY ALERT 🚨\n"
        "I need help! I'm in danger!\n"
        "Name: $userName\n"
        "Location: $locationString\n"
        "Google Maps: $googleMapsUrl\n"
        "Please contact me or emergency services immediately!\n"
        "Time: ${DateTime.now().toString()}";

    // Debug logging
    print('📤 Sending emergency SMS to $contactNumber:');
    print('SMS Body length: ${body.length} characters');
    print(
      'SMS Body preview: ${body.substring(0, body.length > 100 ? 100 : body.length)}...',
    );

    // Try to send SMS with multipart support for long messages
    bool isMultipart = body.length > 160;
    print("Using multipart SMS: $isMultipart");

    print("📱 Calling _telephony.sendSms...");
    await _telephony.sendSms(
      to: contactNumber,
      message: body,
      isMultipart: isMultipart,
    );
    print('✅ Emergency SMS sent successfully to $contactNumber');
  } catch (e) {
    print('❌ Error sending emergency SMS: $e');
    print('Error type: ${e.runtimeType}');

    // Try alternative method using default SMS app
    try {
      print("🔄 Trying alternative SMS method...");
      await _telephony.sendSmsByDefaultApp(
        to: contactNumber,
        message:
            "🚨 EMERGENCY ALERT 🚨\nI need help! Please check my location: $googleMapsUrl",
      );
      print('✅ Emergency SMS sent via default app to $contactNumber');
    } catch (e2) {
      print('❌ Alternative SMS method also failed: $e2');
      rethrow;
    }
  }
}
