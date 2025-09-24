import 'package:flutter/material.dart';
import 'package:ai_women_safety/Ui/screens/chat/chat_screen.dart';
import 'package:ai_women_safety/Ui/screens/home/profile_screen.dart';
import 'package:ai_women_safety/Ui/screens/home/safety_screen.dart';
import 'package:ai_women_safety/Ui/screens/home/emergency_con.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_women_safety/data/services/location_service.dart';
import 'package:ai_women_safety/data/services/emergency_contact_service.dart';
import 'package:ai_women_safety/data/services/admin_panel_service.dart';
import 'package:ai_women_safety/data/models/emergency_contact.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ai_women_safety/data/services/sms_service.dart';

// Add this to your color palette for easy reuse
const Color kPrimaryPink = Color(0xFFF8BBD0);
const Color kLavender = Color(0xFFCE93D8);
const Color kPeach = Color(0xFFFFF3E0);
const Color kTeal = Color(0xFF80CBC4);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  // List of pages for the BottomNavigationBar
  final List<Widget> _pages = [
    const _HomeScreenContent(),
    const ChatScreen(),
    const SafetyAwarenessScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8BBD0), // Soft Pink
              Color(0xFFCE93D8), // Lavender
              Color(0xFFFFF3E0), // Peach
              Color(0xFFB3E5FC), // Light Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.33, 0.66, 1.0],
          ),
        ),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, "Home", 0),
                _buildNavItem(Icons.chat_bubble_rounded, "Chat", 1),
                _buildNavItem(Icons.shield_rounded, "Safety", 2),
                _buildNavItem(Icons.person_rounded, "Profile", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF9C27B0).withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF9C27B0) : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF9C27B0) : Colors.grey[600],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The main content for the home tab
class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool _liveLocation = false;
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _pulseController.repeat(reverse: true);
    _fadeController.forward();
    _slideController.forward();

    _fetchUserName();
    _initializeLocationState();
  }

  Future<void> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        _userName = doc.data()?['name'] ?? "User";
      });
    }
  }

  Future<void> _initializeLocationState() async {
    _liveLocation = LocationService.isLocationEnabled;
    setState(() {});
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleSOSPress() {
    _showSOSDialog();
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.emergency, color: Colors.red, size: 28),
                SizedBox(width: 12),
                Text("Emergency Alert", style: TextStyle(color: Colors.red)),
              ],
            ),
            content: const Text(
              "Are you sure you want to send an emergency alert with your location to your emergency contacts?",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _sendEmergencyAlert();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Send Alert",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleLocationToggle(bool value) async {
    if (value) {
      // Enable location sharing
      _showLoadingSnackBar("Enabling location sharing...");

      bool success = await LocationService.enableLocationSharing();
      if (success) {
        setState(() {
          _liveLocation = true;
        });
        _showSuccessSnackBar("Location sharing enabled successfully");
      } else {
        // Get detailed error message
        String errorMessage = await LocationService.getLocationStatusMessage();
        _showErrorSnackBar(errorMessage);
      }
    } else {
      // Disable location sharing
      LocationService.disableLocationSharing();
      setState(() {
        _liveLocation = false;
      });
      _showSuccessSnackBar("Location sharing disabled");
    }
  }

  Future<void> _checkLocationStatus() async {
    _showLoadingSnackBar("Checking location status...");

    String statusMessage = await LocationService.getLocationStatusMessage();

    // Show detailed status in a dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF9C27B0)),
                SizedBox(width: 8),
                Text("Location Status"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statusMessage),
                const SizedBox(height: 16),
                const Text(
                  "Troubleshooting Tips:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "• Make sure GPS/Location is enabled in device settings",
                ),
                const Text("• Check if the app has location permission"),
                const Text("• Try going outside for better GPS signal"),
                const Text("• Restart the app if issues persist"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  // Try to refresh location
                  _showLoadingSnackBar("Refreshing location...");
                  Position? position = await LocationService.refreshLocation();
                  if (position != null) {
                    _showSuccessSnackBar("Location refreshed successfully!");
                    setState(() {
                      _liveLocation = true;
                    });
                  } else {
                    String errorMessage =
                        await LocationService.getLocationStatusMessage();
                    _showErrorSnackBar(
                      "Could not refresh location. $errorMessage",
                    );
                  }
                },
                child: const Text("Refresh"),
              ),
            ],
          ),
    );
  }

  Future<void> _sendEmergencyAlert() async {
    try {
      _showLoadingSnackBar("Sending emergency alert...");

      // Check SMS permissions first
      bool hasSmsPermission = await checkSmsPermissions();
      if (!hasSmsPermission) {
        _showErrorSnackBar(
          "SMS permission required. Please grant SMS permission to send emergency alerts.",
        );
        return;
      }

      // Get current location
      Position? position = await LocationService.getCurrentLocation();
      if (position == null) {
        // Try to refresh location once more
        position = await LocationService.refreshLocation();
        if (position == null) {
          String errorMessage =
              await LocationService.getLocationStatusMessage();
          _showErrorSnackBar("Could not get your location. $errorMessage");
          return;
        }
      }

      // Create location string directly from the position
      String locationString =
          "📍 Current Location:\n"
          "Latitude: ${position.latitude.toStringAsFixed(6)}\n"
          "Longitude: ${position.longitude.toStringAsFixed(6)}\n"
          "Accuracy: ${position.accuracy.toStringAsFixed(1)}m\n"
          "Time: ${DateTime.fromMillisecondsSinceEpoch(position.timestamp.millisecondsSinceEpoch).toString().substring(0, 19)}";

      // Create Google Maps URL with better compatibility
      String googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      // Debug logging
      print("Location data for SMS:");
      print("Position: ${position.latitude}, ${position.longitude}");
      print("Location String: $locationString");
      print("Google Maps URL: $googleMapsUrl");

      // Verify location data is valid
      if (position.latitude == 0.0 && position.longitude == 0.0) {
        _showErrorSnackBar("Invalid location data received. Please try again.");
        return;
      }

      // Send alert to admin panel
      print("📡 Sending alert to admin panel...");
      try {
        await AdminPanelService.sendEmergencyAlertToPolice(
          position: position,
          locationString: locationString,
          googleMapsUrl: googleMapsUrl,
          additionalInfo:
              "Emergency alert from ${_userName.isNotEmpty ? _userName : "User"}",
        );
        print("✅ Alert sent to admin panel successfully");
      } catch (e) {
        print("❌ Failed to send alert to admin panel: $e");
      }

      // Fetch emergency contacts from Firestore
      List<EmergencyContact> contacts =
          await EmergencyContactService.getEmergencyContacts().first;

      // Send SMS to each contact using the emergency alert SMS service
      if (contacts.isNotEmpty) {
        int successCount = 0;
        int totalContacts = contacts.length;

        for (final contact in contacts) {
          if (contact.phoneNumber.isNotEmpty) {
            try {
              await sendEmergencyAlertSMS(
                contact.phoneNumber,
                _userName.isNotEmpty ? _userName : "User",
                locationString,
                googleMapsUrl,
              );
              successCount++;
            } catch (e) {
              print('Failed to send SMS to ${contact.name}: $e');
              // Continue with other contacts even if one fails
            }
          }
        }

        if (successCount > 0) {
          _showSuccessSnackBar(
            "Emergency alert sent to $successCount out of $totalContacts contacts!",
          );
        } else {
          _showErrorSnackBar(
            "Failed to send emergency alert to any contacts. Please check SMS permissions.",
          );
        }
      } else {
        _showErrorSnackBar(
          "No emergency contacts found. Please add emergency contacts first.",
        );
      }
    } catch (e) {
      _showErrorSnackBar("Error sending emergency alert: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildSafetyStatus(),
              _buildSOSButton(),
              _buildQuickActions(),
              _buildEmergencyContacts(),
              _buildSafetyTips(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kPeach.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kPrimaryPink.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(
              // Replace with user's profilePicUrl if available
              "https://cdn-icons-png.flaticon.com/512/2922/2922561.png",
            ),
            backgroundColor: kLavender,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, $_userName!",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kLavender,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "You’re safe and connected 💖",
                  style: TextStyle(
                    fontSize: 16,
                    color: kTeal,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Safety Status: All Good",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Location sharing is active • Emergency contacts ready",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: _liveLocation,
                onChanged: _handleLocationToggle,
                activeColor: const Color(0xFF9C27B0),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: _checkLocationStatus,
                icon: const Icon(Icons.info_outline, size: 20),
                tooltip: "Check location status",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSOSButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: GestureDetector(
                  onTap: _handleSOSPress,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE53E3E), Color(0xFFC53030)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "SOS",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const Text(
            "Tap to send emergency alert",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  "Emergency Contacts",
                  "Quick access to contacts",
                  Icons.contacts_rounded,
                  const Color(0xFF00BCD4),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmergencyContactsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emergency, color: Color(0xFFE53E3E), size: 20),
              SizedBox(width: 8),
              Text(
                "Emergency Contacts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('emergencyContacts') // <-- match Firestore
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No emergency contacts added yet.");
              }
              return Column(
                children:
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildContactItem(
                        data['name'] ?? '',
                        data['phoneNumber'] ?? '',
                        Icons.person,
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(String name, String phone, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFE53E3E), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  phone,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone, color: Color(0xFFE53E3E), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTips() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Color(0xFFFF9800), size: 20),
              SizedBox(width: 8),
              Text(
                "Safety Tip of the Day",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Always share your location with trusted contacts when traveling alone, especially at night. Use well-lit routes and stay aware of your surroundings.",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4A5568),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
