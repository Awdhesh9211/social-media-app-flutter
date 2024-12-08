import 'package:mediasocial/entities/models/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
  });

  // method to update user profile
  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      followers: newFollowers ?? followers,
      following: newFollowing ?? following,
    );
  }

  // user -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
    };
  }

  // json -> user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'] ?? '', // Ensure we have a valid UID
      email: json['email'] ?? '', // Default empty string if missing
      name: json['name'] ?? '', // Default empty string if missing
      bio: json['bio'] ?? '', // Handle missing bio with default empty string
      profileImageUrl:
          json['profileImageUrl'] ?? '', // Default empty string if missing
      followers: List<String>.from(
          json['followers'] ?? []), // Empty list if followers are missing
      following: List<String>.from(
          json['following'] ?? []), // Empty list if following is missing
    );
  }
}
