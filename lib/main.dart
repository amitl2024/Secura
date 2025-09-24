import 'package:ai_women_safety/Ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Ui/screens/auth/login_screen.dart';
import 'Ui/screens/auth/signup_screen.dart';
import 'Ui/screens/admin/admin_panel_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_women_safety/data/services/admin_auth_service.dart';
import 'package:ai_women_safety/data/services/location_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "assets/.env");

  // Initialize location service (request permissions)
  print('🚀 Initializing location service...');
  try {
    await LocationService.requestLocationPermission();
    print('✅ Location service initialized');
  } catch (e) {
    print('⚠️ Location service initialization failed: $e');
  }

  // Check if user is logged in
  final user = FirebaseAuth.instance.currentUser;
  final isAdminLoggedIn = await AdminAuthService.isAdminLoggedIn();

  String initialRoute;
  if (isAdminLoggedIn) {
    initialRoute = '/admin';
  } else if (user != null) {
    initialRoute = '/home';
  } else {
    initialRoute = '/login';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Women Safety',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminPanelScreen(),
      },
    );
  }
}
