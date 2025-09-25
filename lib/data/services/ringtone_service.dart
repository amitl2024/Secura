import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class RingtoneService {
  static final RingtoneService _instance = RingtoneService._internal();
  factory RingtoneService() => _instance;
  RingtoneService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _vibrationTimer;
  Timer? _soundTimer;
  bool _isPlaying = false;

  // Start ringtone and vibration
  Future<void> startRingtone() async {
    if (_isPlaying) {
      print('Ringtone already playing');
      return;
    }

    print('Starting ringtone...');
    _isPlaying = true;

    try {
      // Start vibration pattern
      print('Starting vibration pattern...');
      _startVibrationPattern();

      // Start sound pattern
      print('Starting sound pattern...');
      await _startSoundPattern();

      print('✅ Ringtone started successfully');
    } catch (e) {
      print('❌ Error starting ringtone: $e');
      // Fallback to haptic feedback only
      print('🔄 Falling back to haptic feedback...');
      _startHapticPattern();
    }
  }

  // Stop ringtone and vibration
  Future<void> stopRingtone() async {
    if (!_isPlaying) return;

    _isPlaying = false;

    try {
      await _audioPlayer.stop();
      _vibrationTimer?.cancel();
      _soundTimer?.cancel();

      print('Ringtone stopped');
    } catch (e) {
      print('Error stopping ringtone: $e');
    }
  }

  // Start sound pattern with actual audio
  Future<void> _startSoundPattern() async {
    try {
      print('🎵 Starting sound pattern...');
      // Try to play a system sound or use haptic feedback as fallback
      if (Platform.isAndroid) {
        print('📱 Android detected - using system sounds');
        // For Android, we'll use system sounds
        await _playSystemSound();
      } else {
        print('🍎 iOS detected - using haptic feedback');
        // For iOS, use haptic feedback
        _startHapticPattern();
      }
    } catch (e) {
      print('❌ Error playing audio: $e');
      _startHapticPattern();
    }
  }

  // Play system sound
  Future<void> _playSystemSound() async {
    try {
      // Use a simple beep pattern to simulate ringtone
      _soundTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (_isPlaying) {
          // Play a short beep sound
          _playBeepSound();
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      print('Error playing system sound: $e');
      _startHapticPattern();
    }
  }

  // Play beep sound using system sound
  Future<void> _playBeepSound() async {
    try {
      print('🔊 Playing beep sound...');
      // Use system sound for beep
      SystemSound.play(SystemSoundType.alert);

      // Add a second beep after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_isPlaying) {
          print('🔊 Playing second beep...');
          SystemSound.play(SystemSoundType.alert);
        }
      });
    } catch (e) {
      print('❌ Error playing beep: $e');
    }
  }

  // Start haptic pattern as fallback
  void _startHapticPattern() {
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

  // Start haptic pattern (replaces vibration)
  void _startVibrationPattern() {
    _vibrationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isPlaying) {
        _vibrate();
      } else {
        timer.cancel();
      }
    });
  }

  // Vibrate with haptic feedback pattern
  Future<void> _vibrate() async {
    try {
      print('📳 Using haptic feedback for vibration...');
      // Use haptic feedback instead of vibration
      HapticFeedback.heavyImpact();

      // Add a pattern of haptic feedback
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_isPlaying) {
          HapticFeedback.mediumImpact();
        }
      });
    } catch (e) {
      print('❌ Error with haptic feedback: $e');
      // Fallback to light haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  // Check if ringtone is playing
  bool get isPlaying => _isPlaying;

  // Dispose resources
  void dispose() {
    stopRingtone();
    _audioPlayer.dispose();
  }
}
