import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_women_safety/data/services/fake_call_service.dart';
import 'package:ai_women_safety/data/services/ringtone_service.dart';
import 'package:ai_women_safety/Ui/screens/home/emergency_con.dart';

class FakeCallScreen extends StatefulWidget {
  final String? callerName;
  final String? callerNumber;
  final String? callerAvatar;

  const FakeCallScreen({
    Key? key,
    this.callerName,
    this.callerNumber,
    this.callerAvatar,
  }) : super(key: key);

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen>
    with TickerProviderStateMixin {
  final FakeCallService _fakeCallService = FakeCallService();
  final RingtoneService _ringtoneService = RingtoneService();

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  bool _isAnswered = false;
  int _callDuration = 0;
  Timer? _callTimer;
  Timer? _ringtoneTimer;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start the fake call
    _startFakeCall();

    // Start pulse animation
    _pulseController.repeat(reverse: true);

    // Start glow animation
    _glowController.repeat(reverse: true);

    // Start slide animation
    _slideController.forward();

    // Set system UI overlay style for full-screen call experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    _callTimer?.cancel();
    _ringtoneTimer?.cancel();

    // Stop ringtone
    _ringtoneService.stopRingtone();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  void _startFakeCall() {
    _fakeCallService.startFakeCall(
      callerName: widget.callerName,
      callerNumber: widget.callerNumber,
      callerAvatar: widget.callerAvatar,
    );
  }

  void _answerCall() {
    setState(() {
      _isAnswered = true;
    });

    _fakeCallService.answerFakeCall();
    _pulseController.stop();

    // Start call duration timer
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _declineCall() {
    _fakeCallService.declineFakeCall();
    _endCall();
  }

  void _endCall() {
    _fakeCallService.endFakeCall();
    _callTimer?.cancel();

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  String _formatCallDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d), Color(0xFF1a1a1a)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Status bar area
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isAnswered
                          ? _formatCallDuration(_callDuration)
                          : 'Incoming call',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_isAnswered)
                      const Icon(
                        Icons.signal_cellular_4_bar,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),
              ),

              // Main call content
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Caller avatar with enhanced animations
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _pulseAnimation,
                          _glowAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isAnswered ? 1.0 : _pulseAnimation.value,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow:
                                    _isAnswered
                                        ? []
                                        : [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.3 * _glowAnimation.value,
                                            ),
                                            blurRadius:
                                                20 * _glowAnimation.value,
                                            spreadRadius:
                                                10 * _glowAnimation.value,
                                          ),
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(
                                              0.2 * _glowAnimation.value,
                                            ),
                                            blurRadius:
                                                30 * _glowAnimation.value,
                                            spreadRadius:
                                                15 * _glowAnimation.value,
                                          ),
                                        ],
                              ),
                              child: Center(
                                child: Text(
                                  widget.callerAvatar ??
                                      _fakeCallService.fakeCallerAvatar,
                                  style: const TextStyle(fontSize: 80),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Caller name
                      Text(
                        widget.callerName ?? _fakeCallService.fakeCallerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Caller number
                      Text(
                        widget.callerNumber ??
                            _fakeCallService.fakeCallerNumber,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Call status
                      if (_isAnswered)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                            ),
                          ),
                          child: const Text(
                            'Connected',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),

              // Call controls
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 30,
                ),
                child:
                    _isAnswered
                        ? _buildAnsweredControls()
                        : _buildIncomingControls(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomingControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Decline button
        _buildCallButton(
          icon: Icons.call_end,
          color: Colors.red,
          onTap: _declineCall,
        ),

        // Answer button
        _buildCallButton(
          icon: Icons.call,
          color: Colors.green,
          onTap: _answerCall,
        ),
      ],
    );
  }

  Widget _buildAnsweredControls() {
    return Column(
      children: [
        // Emergency button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmergencyContactsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.emergency, color: Colors.white),
            label: const Text(
              'Emergency Contacts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),

        // End call button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCallButton(
              icon: Icons.call_end,
              color: Colors.red,
              onTap: _endCall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        // Add haptic feedback
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
