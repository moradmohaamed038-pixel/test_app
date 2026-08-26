import 'package:firebase_database/firebase_database.dart';

class UserService {
  static final _database = FirebaseDatabase.instance;

  static Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      await _database.ref('users/$uid').set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      print('✅ User profile saved');
    } catch (e) {
      print('❌ Error saving user profile: $e');
    }
  }

  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final snapshot = await _database.ref('users/$uid').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  static Stream<DatabaseEvent> getUserProfileStream(String uid) {
    return _database.ref('users/$uid').onValue;
  }

  static Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();
      await _database.ref('users/$uid').update(data);
      print('✅ User profile updated');
    } catch (e) {
      print('❌ Error updating user profile: $e');
    }
  }
}