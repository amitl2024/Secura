import 'package:flutter/material.dart';
import 'package:ai_women_safety/data/services/fake_call_service.dart';
import 'package:ai_women_safety/Ui/screens/fake_call/fake_call_screen.dart';

class FakeCallCallerSelectionScreen extends StatefulWidget {
  const FakeCallCallerSelectionScreen({Key? key}) : super(key: key);

  @override
  State<FakeCallCallerSelectionScreen> createState() =>
      _FakeCallCallerSelectionScreenState();
}

class _FakeCallCallerSelectionScreenState
    extends State<FakeCallCallerSelectionScreen> {
  String _selectedCallerName = '';
  String _selectedCallerNumber = '';
  String _selectedCallerAvatar = '';

  @override
  void initState() {
    super.initState();
    // Set default selection
    _selectedCallerName = FakeCallService.predefinedCallers[0]['name']!;
    _selectedCallerNumber = FakeCallService.predefinedCallers[0]['number']!;
    _selectedCallerAvatar = FakeCallService.predefinedCallers[0]['avatar']!;
  }

  void _startFakeCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FakeCallScreen(
              callerName: _selectedCallerName,
              callerNumber: _selectedCallerNumber,
              callerAvatar: _selectedCallerAvatar,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8BBD0),
      appBar: AppBar(
        title: const Text(
          'Fake Call',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF9C27B0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFCE93D8), Color(0xFFFFF3E0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.phone_in_talk,
                        size: 60,
                        color: Color(0xFF9C27B0),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Caller',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose who should appear to be calling you',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Caller selection
                const Text(
                  'Predefined Callers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: ListView.builder(
                    itemCount: FakeCallService.predefinedCallers.length,
                    itemBuilder: (context, index) {
                      final caller = FakeCallService.predefinedCallers[index];
                      final isSelected = _selectedCallerName == caller['name'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCallerName = caller['name']!;
                                _selectedCallerNumber = caller['number']!;
                                _selectedCallerAvatar = caller['avatar']!;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.white.withOpacity(0.95)
                                        : Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    isSelected
                                        ? Border.all(
                                          color: const Color(0xFF9C27B0),
                                          width: 2,
                                        )
                                        : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF9C27B0,
                                      ).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        caller['avatar']!,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Caller info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          caller['name']!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                isSelected
                                                    ? const Color(0xFF9C27B0)
                                                    : const Color(0xFF2D3748),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          caller['number']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Selection indicator
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF9C27B0),
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Start call button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startFakeCall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 8,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Start Fake Call',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
