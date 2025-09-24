class AdminAuthService {
  static const String _adminEmail = 'admin@gmail.com';
  static const String _adminPassword = 'admin123';

  // Static variables to maintain session (in-memory)
  static bool _isLoggedIn = false;
  static DateTime? _loginTime;

  // Check if credentials are valid
  static bool validateCredentials(String email, String password) {
    return email == _adminEmail && password == _adminPassword;
  }

  // Admin login
  static Future<bool> login(String email, String password) async {
    if (validateCredentials(email, password)) {
      // Store admin login state in memory
      _isLoggedIn = true;
      _loginTime = DateTime.now();
      print("✅ Admin login successful - session saved");
      return true;
    }
    return false;
  }

  // Check if admin is logged in
  static Future<bool> isAdminLoggedIn() async {
    print("Admin login status: $_isLoggedIn");
    return _isLoggedIn;
  }

  // Admin logout
  static Future<void> logout() async {
    try {
      _isLoggedIn = false;
      _loginTime = null;
      print("✅ Admin logout successful - session cleared");
    } catch (e) {
      print("Error during admin logout: $e");
    }
  }

  // Get admin login time
  static Future<DateTime?> getAdminLoginTime() async {
    return _loginTime;
  }
}
