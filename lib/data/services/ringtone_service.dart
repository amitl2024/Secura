import 'dart:async';
import 'package:flutter/services.dart';

class RingtoneService {
  static final RingtoneService _instance = RingtoneService._internal();
  factory RingtoneService() => _instance;
  RingtoneService._internal();

  Timer? _vibrationTimer;
  Timer? _soundTimer;
  bool _isPlaying = false;

  // Start ringtone and vibration
  Future<void> startRingtone() async {
    if (_isPlaying) return;

    _isPlaying = true;

    try {
      // Start vibration pattern
      _startVibrationPattern();

      // Start sound pattern
      _startSoundPattern();

      print('Ringtone started');
    } catch (e) {
      print('Error starting ringtone: $e');
    }
  }

  // Stop ringtone and vibration
  Future<void> stopRingtone() async {
    if (!_isPlaying) return;

    _isPlaying = false;

    try {
      _vibrationTimer?.cancel();
      _soundTimer?.cancel();

      print('Ringtone stopped');
    } catch (e) {
      print('Error stopping ringtone: $e');
    }
  }

  // Start sound pattern using HapticFeedback
  void _startSoundPattern() {
    _soundTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isPlaying) {
        // Use different haptic feedback patterns to simulate ringtone
        HapticFeedback.heavyImpact();

        // Add a slight delay and play another sound
        Future.delayed(const Duration(milliseconds: 200), () {
          if (_isPlaying) {
            HapticFeedback.mediumImpact();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  // Start vibration pattern using HapticFeedback
  void _startVibrationPattern() {
    _vibrationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isPlaying) {
        _vibrate();
      } else {
        timer.cancel();
      }
    });
  }

  // Vibrate with pattern using HapticFeedback
  void _vibrate() {
    try {
      // Use HapticFeedback to simulate vibration
      HapticFeedback.heavyImpact();

      // Add a pattern of vibrations
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_isPlaying) {
          HapticFeedback.mediumImpact();
        }
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        if (_isPlaying) {
          HapticFeedback.lightImpact();
        }
      });
    } catch (e) {
      print('Error vibrating: $e');
    }
  }

  // Check if ringtone is playing
  bool get isPlaying => _isPlaying;

  // Dispose resources
  void dispose() {
    stopRingtone();
  }
}
