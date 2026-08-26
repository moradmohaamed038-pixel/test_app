import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential?> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ User registered: ${userCredential.user?.email}');
      return userCredential;
    }  catch (e) {
      print('❌ Registration error: $e');
      return null;
    }
  }

  static Future<UserCredential?> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ User logged in: ${userCredential.user?.email}');
      return userCredential;
    }  catch (e) {
      print('❌ Login error: $e');
      return null;
    }
  }

  static Future<UserCredential?> loginAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      print('✅ Logged in anonymously');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ Anonymous login error: ${e.message}');
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await _auth.signOut();
      print('✅ User logged out');
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  static User? getCurrentUser() => _auth.currentUser;

  static Stream<User?> authStateChanges() => _auth.authStateChanges();
}
