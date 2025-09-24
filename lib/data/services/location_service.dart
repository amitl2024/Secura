import 'package:geolocator/geolocator.dart';

class LocationService {
  static bool _isLocationEnabled = false;
  static Position? _currentPosition;

  // Get current location enabled state
  static bool get isLocationEnabled => _isLocationEnabled;

  // Get current position
  static Position? get currentPosition => _currentPosition;

  // Request location permission
  static Future<bool> requestLocationPermission() async {
    try {
      print('🔍 Checking location services...');

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('📍 Location services enabled: $serviceEnabled');

      if (!serviceEnabled) {
        print('❌ Location services are disabled');
        return false;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      print('🔐 Current permission status: $permission');

      if (permission == LocationPermission.denied) {
        print('📝 Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('🔐 Permission after request: $permission');

        if (permission == LocationPermission.denied) {
          print('❌ Location permission denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Location permission denied forever');
        return false;
      }

      print('✅ Location permission granted');
      return true;
    } catch (e) {
      print('❌ Error requesting location permission: $e');
      return false;
    }
  }

  // Get current location
  static Future<Position?> getCurrentLocation() async {
    try {
      print('🌍 Getting current location...');

      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        print('❌ No location permission, cannot get location');
        return null;
      }

      print('📍 Requesting location with high accuracy...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      print('✅ Location obtained: ${position.latitude}, ${position.longitude}');
      print('📍 Accuracy: ${position.accuracy}m');
      print('⏰ Timestamp: ${position.timestamp}');

      _currentPosition = position;
      return position;
    } catch (e) {
      print('❌ Error getting current location: $e');

      // Try with lower accuracy if high accuracy fails
      try {
        print('🔄 Retrying with medium accuracy...');
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        );

        print(
          '✅ Location obtained with medium accuracy: ${position.latitude}, ${position.longitude}',
        );
        _currentPosition = position;
        return position;
      } catch (e2) {
        print('❌ Failed to get location with medium accuracy: $e2');
        return null;
      }
    }
  }

  // Enable location sharing
  static Future<bool> enableLocationSharing() async {
    try {
      print('🔧 Enabling location sharing...');

      bool hasPermission = await requestLocationPermission();
      if (hasPermission) {
        _isLocationEnabled = true;
        print('✅ Location sharing enabled');

        // Get initial location
        Position? position = await getCurrentLocation();
        if (position != null) {
          print('✅ Initial location obtained successfully');
          return true;
        } else {
          print(
            '⚠️ Location sharing enabled but could not get initial location',
          );
          return true; // Still return true as permission is granted
        }
      } else {
        print('❌ Could not enable location sharing - permission denied');
        return false;
      }
    } catch (e) {
      print('❌ Error enabling location sharing: $e');
      return false;
    }
  }

  // Disable location sharing
  static void disableLocationSharing() {
    _isLocationEnabled = false;
    _currentPosition = null;
  }

  // Get location as formatted string
  static String getLocationString() {
    if (_currentPosition == null) {
      return "Location not available";
    }

    return "Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, "
        "Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}";
  }

  // Get location as Google Maps URL
  static String getGoogleMapsUrl() {
    if (_currentPosition == null) {
      return "";
    }

    return "https://www.google.com/maps?q=${_currentPosition!.latitude},${_currentPosition!.longitude}";
  }

  // Check location service status and provide detailed error message
  static Future<String> getLocationStatusMessage() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return "Location services are disabled. Please enable GPS/Location services in your device settings.";
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      switch (permission) {
        case LocationPermission.denied:
          return "Location permission denied. Please grant location permission in app settings.";
        case LocationPermission.deniedForever:
          return "Location permission permanently denied. Please enable location permission in device settings.";
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          // Try to get location to see if it actually works
          try {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium,
              timeLimit: const Duration(seconds: 5),
            );
            return "Location services working properly. Current location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
          } catch (e) {
            return "Location permission granted but unable to get current location. This might be due to poor GPS signal or being indoors.";
          }
        case LocationPermission.unableToDetermine:
          return "Unable to determine location permission status. Please check app permissions.";
      }
    } catch (e) {
      return "Error checking location status: $e";
    }
  }

  // Force refresh location
  static Future<Position?> refreshLocation() async {
    print('🔄 Force refreshing location...');
    _currentPosition = null; // Clear cached position
    return await getCurrentLocation();
  }
}
