import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../Models/users.dart';
import '../log_page.dart'; // Import LogData class

class UserDatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'User';

  // Add user details
  Future<void> addUserDetails(AppUser user) async {
    final userData = {
      'userId': user.userId,
      'email': user.email,
      'userName': user.userName,
      'phoneNumber': user.phoneNumber,
      'accessToken': user.accessToken,
      'banned': user.banned,
      'role': user.role
    };
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.userId)
          .set(userData);
      LogData.addDebugLog('User added: ${user.userId}');
    } catch (e) {
      Logger().e('Error adding user: $e');
      LogData.addErrorLog('Error adding user: $e');
      // Handle error as per your application's requirements
    }
  }

  // Fetch user details by userId
  Future<AppUser?> fetchUser(String uid) async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .where('userId', isEqualTo: uid)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final user = snapshot.docs.first.data();
      LogData.addDebugLog('User fetched: $uid');

      return AppUser(
          userId: user['userId'],
          userName: user['userName'],
          email: user['email'],
          accessToken: user['accessToken'],
          role: user['role'],
          banned: user['banned'],
          phoneNumber: user['phoneNumber']);
    } catch (e) {
      Logger().e('Error fetching user: $e');
      LogData.addErrorLog('Error fetching user: $e');
      return null; // Handle error or return default value
    }
  }

  // Update user details
  Future<void> updateUserDetails(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update(updatedData);
      LogData.addDebugLog('User updated: $userId');
    } catch (e) {
      Logger().e('Error updating user details: $e');
      LogData.addErrorLog('Error updating user details: $e');
      // Handle error as per your application's requirements
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();
      LogData.addDebugLog('User deleted: $userId');
    } catch (e) {
      Logger().e('Error deleting user: $e');
      LogData.addErrorLog('Error deleting user: $e');
      // Handle error as per your application's requirements
    }
  }

  // Fetch user details by email
  Future<Map<String, dynamic>?> fetchUserByEmail(String email) async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final user = snapshot.docs.first.data();
      LogData.addDebugLog('User fetched by email: $email');
      return {
        'userId': user['userId'],
        'email': user['email'],
        'userName': user['userName'],
        'phoneNumber': user['phoneNumber'],
        'role':
            user['role'], // Assuming 'role' is a field in your user document
      };
    } catch (e) {
      Logger().e('Error fetching user by email: $e');
      LogData.addErrorLog('Error fetching user by email: $e');
      return null; // Handle error or return default value
    }
  }

  // Get all users stream
  Future<Stream<QuerySnapshot>> getUsers() async {
    try {
      return _firestore.collection(_usersCollection).snapshots();
    } catch (e) {
      Logger().e('Error fetching users stream: $e');
      LogData.addErrorLog('Error fetching users stream: $e');
      rethrow; // Rethrow the error for higher-level error handling
    }
  }
}
