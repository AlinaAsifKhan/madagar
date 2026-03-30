import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  // Save user to Firestore after signup
  static Future<void> saveUserProfile({
    required String uid,
    required String phoneNumber,
    required String name,
    required String role,
  }) async {
    try {
      final newUser = UserModel(
        uid: uid,
        phoneNumber: phoneNumber,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .set(newUser.toJson());
    } catch (e) {
      throw Exception('Error saving user profile: $e');
    }
  }

  // Get user profile from Firestore
  static Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  // Stream to listen for user changes
  static Stream<UserModel?> getUserProfileStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Update user profile
  static Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .update(data);
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }
}
