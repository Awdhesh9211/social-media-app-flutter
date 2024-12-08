import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediasocial/entities/models/profile_user.dart';
import 'package:mediasocial/entities/repository/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      print("Fetching user profile for uid: $uid");

      // Get user document
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        // Log the fetched user data

        if (userData != null) {
          // Fetch followers and following
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          ProfileUser user = ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'] ?? '',
            bio: userData['bio'] ?? '', // Default to empty string if null
            profileImageUrl: userData['profileImageUrl'] ??
                '', // Default to empty string if null
            followers: followers,
            following: following,
          );

          print("User fetch success: $user");
          return user;
        } else {
          print("User data is null");
        }
      } else {
        print("User document does not exist for uid: $uid");
      }

      return null; // If user document does not exist or data is null
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      // convert to json and store
      await firebaseFirestore
          .collection('users')
          .doc(updateProfile.uid)
          .update({
        'bio': updateProfile.bio,
        'profileImageUrl': updateProfile.profileImageUrl
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection("users").doc(currentUid).get();
      final targetUserDoc =
          await firebaseFirestore.collection("users").doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List.from(currentUserData['following'] ?? []);
          if (currentFollowing.contains(targetUid)) {
            // unfollow
            await firebaseFirestore.collection("users").doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid])
            });
            await firebaseFirestore.collection("users").doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid])
            });
          } else {
            // follow
            await firebaseFirestore.collection("users").doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid])
            });
            await firebaseFirestore.collection("users").doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid])
            });
          }
        }
      }
    } catch (e) {
      throw Exception("");
    }
  }
}
