import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart'; // Import Firestore service

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email/Password login
  Future<UserCredential?> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return null;
    }
  }

  // Email/Password signup
  Future<UserCredential?> signUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user info in Firestore
      await FirestoreService().addUserToFirestore(
        cred.user!, // User object
        name,
        '', // Phone (optional)
      );

      return cred;
    } catch (e) {
      return null;
    }
  }

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Store Google user info in Firestore
      User? user = userCredential.user;
      if (user != null) {
        await FirestoreService().addGoogleUserToFirestore(user);
      }

      return userCredential;
    } catch (e) {
      return null;
    }
  }
}
