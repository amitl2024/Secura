import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:ai_women_safety/data/services/ringtone_service.dart';

class FakeCallService {
  static final FakeCallService _instance = FakeCallService._internal();
  factory FakeCallService() => _instance;
  FakeCallService._internal();

  final Telephony _telephony = Telephony.instance;
  final RingtoneService _ringtoneService = RingtoneService();

  // Fake call data
  String _fakeCallerName = "Mom";
  String _fakeCallerNumber = "+1 (555) 123-4567";
  String _fakeCallerAvatar = "👩";

  // Call state management
  bool _isFakeCallActive = false;
  Timer? _callTimer;

  // Getters
  bool get isFakeCallActive => _isFakeCallActive;
  String get fakeCallerName => _fakeCallerName;
  String get fakeCallerNumber => _fakeCallerNumber;
  String get fakeCallerAvatar => _fakeCallerAvatar;

  // Set fake caller details
  void setFakeCallerDetails({String? name, String? number, String? avatar}) {
    if (name != null) _fakeCallerName = name;
    if (number != null) _fakeCallerNumber = number;
    if (avatar != null) _fakeCallerAvatar = avatar;
  }

  // Predefined fake callers for quick selection
  static const List<Map<String, String>> predefinedCallers = [
    {'name': 'Mom', 'number': '+1 (555) 123-4567', 'avatar': '👩'},
    {'name': 'Dad', 'number': '+1 (555) 234-5678', 'avatar': '👨'},
    {'name': 'Sister', 'number': '+1 (555) 345-6789', 'avatar': '👧'},
    {'name': 'Best Friend', 'number': '+1 (555) 456-7890', 'avatar': '👭'},
    {'name': 'Boss', 'number': '+1 (555) 567-8901', 'avatar': '👔'},
  ];

  // Start a fake call
  Future<void> startFakeCall({
    String? callerName,
    String? callerNumber,
    String? callerAvatar,
  }) async {
    if (_isFakeCallActive) {
      print('Fake call already active');
      return;
    }

    // Update caller details if provided
    if (callerName != null || callerNumber != null || callerAvatar != null) {
      setFakeCallerDetails(
        name: callerName,
        number: callerNumber,
        avatar: callerAvatar,
      );
    }

    _isFakeCallActive = true;

    // Start ringtone and vibration
    await _ringtoneService.startRingtone();

    // Auto-end call after 30 seconds if not answered
    _callTimer = Timer(const Duration(seconds: 30), () {
      if (_isFakeCallActive) {
        endFakeCall();
      }
    });

    print(
      'Fake call started with caller: $_fakeCallerName ($_fakeCallerNumber)',
    );
  }

  // Answer the fake call
  void answerFakeCall() {
    if (!_isFakeCallActive) return;

    _callTimer?.cancel();
    _ringtoneService.stopRingtone();
    print('Fake call answered');

    // You can add additional logic here for when call is answered
    // For example, start a timer for call duration
  }

  // End the fake call
  void endFakeCall() {
    if (!_isFakeCallActive) return;

    _isFakeCallActive = false;
    _callTimer?.cancel();
    _ringtoneService.stopRingtone();
    print('Fake call ended');
  }

  // Decline the fake call
  void declineFakeCall() {
    if (!_isFakeCallActive) return;

    _isFakeCallActive = false;
    _callTimer?.cancel();
    _ringtoneService.stopRingtone();
    print('Fake call declined');
  }

  // Check if device can make calls (for real emergency calls)
  Future<bool> canMakeCalls() async {
    try {
      // For now, assume device can make calls if telephony is available
      // You can add more sophisticated checks here
      return true;
    } catch (e) {
      print('Error checking phone capability: $e');
      return false;
    }
  }

  // Make a real emergency call
  Future<void> makeRealCall(String phoneNumber) async {
    try {
      await _telephony.dialPhoneNumber(phoneNumber);
    } catch (e) {
      print('Error making real call: $e');
      rethrow;
    }
  }

  // Open dialer with a number
  Future<void> openDialer(String phoneNumber) async {
    try {
      await _telephony.openDialer(phoneNumber);
    } catch (e) {
      print('Error opening dialer: $e');
      rethrow;
    }
  }

  // Request phone permissions
  Future<bool> requestPhonePermissions() async {
    try {
      final bool? granted = await _telephony.requestPhonePermissions;
      return granted ?? false;
    } catch (e) {
      print('Error requesting phone permissions: $e');
      return false;
    }
  }

  // Test ringtone functionality
  Future<void> testRingtone() async {
    print('🧪 Testing ringtone functionality...');
    await _ringtoneService.startRingtone();

    // Stop after 5 seconds for testing
    Timer(const Duration(seconds: 5), () {
      _ringtoneService.stopRingtone();
      print('🧪 Ringtone test completed');
    });
  }
}
