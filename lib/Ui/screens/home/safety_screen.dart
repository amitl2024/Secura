import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

// Common styling constants for better performance and consistency
class _AppStyles {
  static const gradientBackground = BoxDecoration(
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
  );

  static const whiteCardDecoration = BoxDecoration(
    color: Color(0xF2FFFFFF), // Colors.white.withOpacity(0.95)
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Color(0x0D000000), // Colors.black.withOpacity(0.05)
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static const headerCardDecoration = BoxDecoration(
    color: Color(0xF2FFFFFF), // Colors.white.withOpacity(0.95)
    borderRadius: BorderRadius.all(Radius.circular(20)),
    boxShadow: [
      BoxShadow(
        color: Color(0x1A000000), // Colors.black.withOpacity(0.1)
        blurRadius: 15,
        offset: Offset(0, 5),
      ),
    ],
  );

  static const floatingBackButtonDecoration = BoxDecoration(
    color: Color(0xE6FFFFFF), // Colors.white.withOpacity(0.9)
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
    ],
  );
}

class SafetyAwarenessScreen extends StatelessWidget {
  const SafetyAwarenessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: _AppStyles.gradientBackground,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Simple Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _AppStyles.headerCardDecoration,
                child: const Column(
                  children: [
                    Icon(Icons.security, size: 40, color: Color(0xFFE91E63)),
                    SizedBox(height: 12),
                    Text(
                      "Safety Center",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF2D3748),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Your safety resources and quick actions",
                      style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Quick Emergency Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _AppStyles.whiteCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickButton(
                            "SOS Alert",
                            Icons.emergency,
                            const Color(0xFFE53E3E),
                            () => _showQuickAction(
                              context,
                              "🚨 SOS Alert sent to emergency contacts!",
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickButton(
                            "I'm Safe",
                            Icons.verified_user,
                            const Color(0xFF38A169),
                            () => _showQuickAction(
                              context,
                              "✅ I'm Safe message sent!",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickButton(
                            "Share Location",
                            Icons.my_location,
                            const Color(0xFF3182CE),
                            () => _showQuickAction(
                              context,
                              "📍 Location shared with contacts",
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickButton(
                            "Call 112",
                            Icons.phone,
                            const Color(0xFFD69E2E),
                            () => _showQuickAction(
                              context,
                              "📞 Calling emergency services...",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Main Navigation Cards
              _buildMainCard(
                "Safety Tips & Guide",
                "Learn essential safety tips and awareness",
                Icons.shield,
                const Color(0xFF9C27B0),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SafetyTipsPage()),
                ),
              ),
              const SizedBox(height: 16),

              _buildMainCard(
                "Health & Wellness",
                "Physical and mental health resources",
                Icons.favorite,
                const Color(0xFF00BCD4),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HealthTipsPage()),
                ),
              ),
              const SizedBox(height: 16),

              _buildMainCard(
                "Awareness Center",
                "Important awareness information and campaigns",
                Icons.lightbulb,
                const Color(0xFFFF9800),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AwarenessPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    const borderRadius = BorderRadius.all(Radius.circular(12));

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: borderRadius,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    const borderRadius = BorderRadius.all(Radius.circular(16));
    const iconBorderRadius = BorderRadius.all(Radius.circular(12));

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000), // Colors.black.withOpacity(0.05)
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: iconBorderRadius,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  void _showQuickAction(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Safety & Wellbeing",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Resources, tips and quick actions to keep you safe",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSafetyActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: "Safety Checklist",
                subtitle: "Plan ahead and stay ready",
                color: const Color(0xFF9C27B0),
                icon: Icons.checklist_rounded,
                onTap: () => _showSafetyChecklist(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                title: "I'm Safe",
                subtitle: "Send a quick check-in",
                color: const Color(0xFF00BCD4),
                icon: Icons.favorite_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Shared 'I'm Safe' status")),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: "Share ETA",
                subtitle: "Let contacts track you",
                color: const Color(0xFFFF9800),
                icon: Icons.directions_walk_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Share ETA coming soon")),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                title: "Helplines",
                subtitle: "Find assistance",
                color: const Color(0xFFE91E63),
                icon: Icons.support_agent,
                onTap: () => _showHelplinesSheet(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSafetyChecklist(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final items = [
          'Emergency contacts added',
          'Location sharing enabled',
          'Safe route planned',
          'Phone fully charged',
        ];
        final completed = List<bool>.filled(items.length, false);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Safety Checklist',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(items.length, (i) {
                    return CheckboxListTile(
                      value: completed[i],
                      onChanged:
                          (v) => setSheetState(() => completed[i] = v ?? false),
                      title: Text(items[i]),
                      activeColor: const Color(0xFF9C27B0),
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showHelplinesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Helplines',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                _helplineTile(context, 'Emergency (India)', '112'),
                _helplineTile(context, 'Women Helpline (India)', '1091'),
                _helplineTile(context, 'Cyber Crime', '1930'),
              ],
            ),
          ),
    );
  }

  Widget _helplineTile(BuildContext context, String label, String number) {
    return ListTile(
      leading: const Icon(Icons.phone_in_talk, color: Color(0xFFE91E63)),
      title: Text(label),
      subtitle: Text(number),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dial $number (intent coming soon)')),
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _AwarenessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<IconData> subIcons;
  final Color color;
  final VoidCallback onTap;

  const _AwarenessCard({
    required this.title,
    required this.icon,
    required this.subIcons,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 36, color: Colors.deepPurple),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children:
                        subIcons
                            .map(
                              (i) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  i,
                                  size: 22,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.deepPurple,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy pages for navigation (replace with your actual pages)
class SafetyTipsPage extends StatefulWidget {
  const SafetyTipsPage({super.key});

  @override
  State<SafetyTipsPage> createState() => _SafetyTipsPageState();
}

class _SafetyTipsPageState extends State<SafetyTipsPage>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  int _selectedCategory = 0;

  static const List<String> _categories = [
    'Personal',
    'Digital',
    'Travel',
    'Emergency',
  ];

  static const Duration _animationDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Stack(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildSafetyHeader(),
                    _buildSafetyCategoryTabs(),
                    Expanded(child: _buildSafetyContent()),
                  ],
                ),
              ),
              _buildFloatingBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Safety Tips & Guide",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Essential safety tips for women's security",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyCategoryTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                        : null,
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color:
                      isSelected ? const Color(0xFFE91E63) : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSafetyContent() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          "Personal Safety Tips",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildSafetyTipCard(
          icon: Icons.visibility,
          title: "Stay Alert & Aware",
          description:
              "Keep your head up, avoid distractions in unfamiliar areas",
          color: const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 12),
        _buildSafetyTipCard(
          icon: Icons.psychology,
          title: "Trust Your Instincts",
          description:
              "If something feels wrong, remove yourself from the situation",
          color: const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        _buildSafetyTipCard(
          icon: Icons.light_mode,
          title: "Stay in Well-Lit Areas",
          description: "Avoid dark alleys and poorly lit areas at night",
          color: const Color(0xFFFF9800),
        ),
        const SizedBox(height: 12),
        _buildSafetyTipCard(
          icon: Icons.groups,
          title: "Use the Buddy System",
          description: "Travel with friends when possible, especially at night",
          color: const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildSafetyTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBackButton(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        decoration: _AppStyles.floatingBackButtonDecoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HealthTipsPage extends StatefulWidget {
  const HealthTipsPage({super.key});

  @override
  State<HealthTipsPage> createState() => _HealthTipsPageState();
}

class _HealthTipsPageState extends State<HealthTipsPage>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  int _selectedCategory = 0;

  static const List<String> _categories = [
    'Physical',
    'Mental',
    'Nutrition',
    'Sleep',
  ];
  static const Duration _animationDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Stack(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildCategoryTabs(),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
              _buildHealthFloatingBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health & Wellness",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Tips and resources for your physical and mental wellbeing",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                        : null,
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color:
                      isSelected ? const Color(0xFF00BCD4) : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedCategory) {
      case 0:
        return _buildPhysicalHealth();
      case 1:
        return _buildMentalHealth();
      case 2:
        return _buildNutrition();
      case 3:
        return _buildSleep();
      default:
        return _buildPhysicalHealth();
    }
  }

  Widget _buildPhysicalHealth() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionTitle("Exercise Videos"),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _VideoPlayerCard(
                videoUrl:
                    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                title: 'Morning Yoga Flow',
                duration: '15 min',
              ),
              SizedBox(width: 12),
              _VideoPlayerCard(
                videoUrl: 'https://samplelib.com/mp4/sample-5s.mp4',
                title: 'Core Workout',
                duration: '10 min',
              ),
              SizedBox(width: 12),
              _VideoPlayerCard(
                videoUrl: 'https://samplelib.com/mp4/sample-10s.mp4',
                title: 'Stretching Routine',
                duration: '8 min',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle("Quick Tips"),
        const SizedBox(height: 16),
        _buildTipCard(
          icon: Icons.directions_walk,
          title: "Daily Steps Goal",
          description:
              "Aim for 10,000 steps daily for better cardiovascular health",
          color: const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 12),
        _buildTipCard(
          icon: Icons.water_drop,
          title: "Stay Hydrated",
          description: "Drink 8-10 glasses of water throughout the day",
          color: const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        _buildTipCard(
          icon: Icons.timer,
          title: "Take Breaks",
          description: "Every 30 minutes, take a 5-minute break to stretch",
          color: const Color(0xFFFF9800),
        ),
      ],
    );
  }

  Widget _buildMentalHealth() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionTitle("Mindfulness & Meditation"),
        const SizedBox(height: 16),
        _buildMeditationCard(
          title: "5-Minute Breathing Exercise",
          description: "Quick stress relief technique",
          duration: "5 min",
          color: const Color(0xFF9C27B0),
        ),
        const SizedBox(height: 12),
        _buildMeditationCard(
          title: "Body Scan Meditation",
          description: "Relax and release tension",
          duration: "10 min",
          color: const Color(0xFF673AB7),
        ),
        const SizedBox(height: 12),
        _buildMeditationCard(
          title: "Gratitude Practice",
          description: "Focus on positive aspects of your day",
          duration: "7 min",
          color: const Color(0xFF3F51B5),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle("Journaling Prompts"),
        const SizedBox(height: 16),
        _buildJournalPrompt("What are three things I'm grateful for today?"),
        _buildJournalPrompt("What emotions am I feeling right now and why?"),
        _buildJournalPrompt(
          "What's one thing I can do tomorrow to take care of myself?",
        ),
      ],
    );
  }

  Widget _buildNutrition() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionTitle("Healthy Eating Tips"),
        const SizedBox(height: 16),
        _buildNutritionCard(
          title: "Balanced Meals",
          description: "Include protein, carbs, and healthy fats in every meal",
          icon: Icons.restaurant,
          color: const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 12),
        _buildNutritionCard(
          title: "Portion Control",
          description: "Use your hand as a guide for portion sizes",
          icon: Icons.scale,
          color: const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        _buildNutritionCard(
          title: "Meal Prep",
          description: "Prepare healthy meals in advance for busy days",
          icon: Icons.kitchen,
          color: const Color(0xFFFF9800),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle("Hydration Tracker"),
        const SizedBox(height: 16),
        _buildHydrationTracker(),
      ],
    );
  }

  Widget _buildSleep() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionTitle("Sleep Hygiene Tips"),
        const SizedBox(height: 16),
        _buildSleepTip(
          title: "Consistent Sleep Schedule",
          description: "Go to bed and wake up at the same time every day",
          icon: Icons.schedule,
        ),
        _buildSleepTip(
          title: "Screen-Free Bedroom",
          description: "Avoid screens 1 hour before bedtime",
          icon: Icons.phone_android,
        ),
        _buildSleepTip(
          title: "Comfortable Environment",
          description: "Keep your room cool, dark, and quiet",
          icon: Icons.bed,
        ),
        const SizedBox(height: 24),
        _buildSectionTitle("Relaxation Techniques"),
        const SizedBox(height: 16),
        _buildRelaxationCard(
          title: "Progressive Muscle Relaxation",
          description: "Tense and release each muscle group",
          duration: "15 min",
        ),
        const SizedBox(height: 12),
        _buildRelaxationCard(
          title: "4-7-8 Breathing",
          description: "Inhale for 4, hold for 7, exhale for 8",
          duration: "5 min",
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard({
    required String title,
    required String description,
    required String duration,
    required Color color,
  }) {
    return Container(
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalPrompt(String prompt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          const Icon(Icons.edit_note, color: Color(0xFF9C27B0), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              prompt,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHydrationTracker() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            "Today's Water Intake",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (index) {
              return Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: index < 4 ? const Color(0xFF2196F3) : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 16,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          const Text(
            "4/8 glasses",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTip({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9C27B0), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelaxationCard({
    required String title,
    required String description,
    required String duration,
  }) {
    return Container(
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.spa, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9C27B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthFloatingBackButton(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        decoration: _AppStyles.floatingBackButtonDecoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoPlayerCard extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String duration;
  const _VideoPlayerCard({
    required this.videoUrl,
    required this.title,
    required this.duration,
  });

  @override
  State<_VideoPlayerCard> createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<_VideoPlayerCard> {
  late final VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _initialized = true;
          _controller.play(); // Auto play video
        });
      }
    } catch (e) {
      // Handle video initialization error
      if (mounted) {
        setState(() {
          _initialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child:
                _initialized ? _buildVideoPlayer() : _buildLoadingIndicator(),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            widget.duration,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),
          GestureDetector(
            onTap: _togglePlayback,
            child: Icon(
              _controller.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              color: Colors.white70,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 100,
      color: Colors.black12,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  void _togglePlayback() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String text;
  const _TipCard({
    required this.icon,
    required this.iconBg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.black54, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AwarenessPage extends StatelessWidget {
  const AwarenessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.campaign,
                          size: 40,
                          color: Color(0xFFFF9800),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Awareness Center",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xFF2D3748),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Important awareness information and campaigns",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Awareness Topics
                  _buildAwarenessCard(
                    "Women's Rights",
                    "Know your rights and legal protections",
                    Icons.gavel,
                    const Color(0xFF9C27B0),
                    () => _showAwarenessDialog(
                      context,
                      "Women's Rights",
                      "Every woman has the right to safety, equality, and freedom from violence. Know your legal rights and available protections.",
                      "https://www.womendeserve.org/women-rights",
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildAwarenessCard(
                    "Cyber Safety",
                    "Protect yourself online and in digital spaces",
                    Icons.security,
                    const Color(0xFF673AB7),
                    () => _showAwarenessDialog(
                      context,
                      "Cyber Safety",
                      "Be cautious of online predators, protect personal information, and report cyberbullying or harassment.",
                      "https://cybercrime.gov.in/Webform/Crime_OnlineSafetyTips.aspx",
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildAwarenessCard(
                    "Workplace Safety",
                    "Know your rights in professional environments",
                    Icons.work,
                    const Color(0xFF3F51B5),
                    () => _showAwarenessDialog(
                      context,
                      "Workplace Safety",
                      "You have the right to a harassment-free workplace. Know how to report incidents and seek support.",
                      "https://www.vantagecircle.com/en/blog/womens-safety-workplace/",
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildAwarenessCard(
                    "Health Awareness",
                    "Important health information for women",
                    Icons.favorite,
                    const Color(0xFFE91E63),
                    () => _showAwarenessDialog(
                      context,
                      "Health Awareness",
                      "Regular health checkups, mental health support, and knowing the signs of health issues are crucial.",
                      "https://www.niehs.nih.gov/research/programs/wha",
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildAwarenessCard(
                    "Financial Safety",
                    "Protect yourself from financial abuse",
                    Icons.account_balance_wallet,
                    const Color(0xFF4CAF50),
                    () => _showAwarenessDialog(
                      context,
                      "Financial Safety",
                      "Maintain financial independence, protect banking information, and be aware of financial manipulation tactics.",
                      "https://www.fbi.gov/services/threat-based-reports/financial-fraud",
                    ),
                  ),
                ],
              ),
              _buildAwarenessFloatingBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAwarenessFloatingBackButton(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        decoration: _AppStyles.floatingBackButtonDecoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAwarenessCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  void _showAwarenessDialog(
    BuildContext context,
    String title,
    String content,
    String url, // add URL parameter
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () async {
                  final Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open link')),
                    );
                  }
                },
                child: const Text('Learn More'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it!'),
              ),
            ],
          ),
    );
  }
}
