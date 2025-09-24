import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  // Send location message to WhatsApp
  static Future<bool> sendLocationMessage(
    String phoneNumber,
    String locationString,
    String googleMapsUrl,
  ) async {
    try {
      // Clean phone number (remove any non-digit characters except +)
      String cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // If phone number doesn't start with +, add country code (assuming India +91)
      if (!cleanPhoneNumber.startsWith('+')) {
        if (cleanPhoneNumber.startsWith('91')) {
          cleanPhoneNumber = '+$cleanPhoneNumber';
        } else {
          cleanPhoneNumber = '+91$cleanPhoneNumber';
        }
      }

      // Create the message with location
      String message =
          "🚨 EMERGENCY ALERT 🚨\n\n"
          "I need help! Please check my location:\n\n"
          "📍 Location: $locationString\n\n"
          "🗺️ View on Google Maps: $googleMapsUrl\n\n"
          "Please contact me immediately or call emergency services if needed.\n\n"
          "This is an automated message from my safety app.";

      // Encode the message for URL
      String encodedMessage = Uri.encodeComponent(message);

      // Create WhatsApp URL with location
      String whatsappUrl =
          "https://wa.me/$cleanPhoneNumber?text=$encodedMessage";

      // Launch WhatsApp
      Uri uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        print('Could not launch WhatsApp');
        return false;
      }
    } catch (e) {
      print('Error sending WhatsApp message: $e');
      return false;
    }
  }

  // Send emergency message to multiple contacts
  static Future<void> sendEmergencyMessages(
    List<String> phoneNumbers,
    String locationString,
    String googleMapsUrl,
  ) async {
    for (String phoneNumber in phoneNumbers) {
      await sendLocationMessage(phoneNumber, locationString, googleMapsUrl);
      // Add a small delay between messages
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // Send emergency alert to all contacts at once (for better UX)
  static Future<void> sendEmergencyToAllContacts(
    List<String> phoneNumbers,
    String locationString,
    String googleMapsUrl,
  ) async {
    if (phoneNumbers.isEmpty) return;

    // Create the message
    String message =
        "🚨 EMERGENCY ALERT 🚨\n\n"
        "I need help! Please check my location:\n\n"
        "📍 Location: $locationString\n\n"
        "🗺️ View on Google Maps: $googleMapsUrl\n\n"
        "Please contact me immediately or call emergency services if needed.\n\n"
        "This is an automated message from my safety app.";

    // Encode the message for URL
    String encodedMessage = Uri.encodeComponent(message);

    // Create WhatsApp URL for the first contact
    String firstPhoneNumber = phoneNumbers.first.replaceAll(
      RegExp(r'[^\d+]'),
      '',
    );
    if (!firstPhoneNumber.startsWith('+')) {
      if (firstPhoneNumber.startsWith('91')) {
        firstPhoneNumber = '+$firstPhoneNumber';
      } else {
        firstPhoneNumber = '+91$firstPhoneNumber';
      }
    }

    String whatsappUrl = "https://wa.me/$firstPhoneNumber?text=$encodedMessage";

    // Launch WhatsApp
    Uri uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
