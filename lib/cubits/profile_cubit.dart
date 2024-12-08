import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/entities/models/profile_user.dart';
import 'package:mediasocial/entities/repository/profile_repo.dart';
import 'package:mediasocial/cubits/states/profile_states.dart';
import 'package:mediasocial/entities/repository/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    print("uid=  $uid");
    print("fetch profile");
    emit(ProfileLoading());
    try {
      final user = await profileRepo.fetchUserProfile(uid);
      print(user);
      if (user != null) {
        emit(ProfileLoaded(profileUser: user));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  // return user profile give uid
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  // update profile using repo
  Future<void> updateProfile(
      {required String uid,
      required String? newBio,
      Uint8List? imageWebBytes,
      String? imageMobilepath}) async {
    emit(ProfileLoading());
    print("update Method..");
    try {
      // fetch current user Profile
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(
            ProfileError(message: "Failed to fetch user for updating profile"));
        return;
      }

      // profile picture update
      String? imageDownloadUrl;
      if (imageWebBytes != null || imageMobilepath != null) {
        if (imageWebBytes != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfilleImageWeb(imageWebBytes, uid);
        }

        if (imageMobilepath != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageMobile(imageMobilepath, uid);
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError(message: "Failed to uppload image"));
          return;
        }
      }

      // update new profile
      final updatedProfile = currentUser.copyWith(
          newBio: newBio ?? currentUser.bio,
          newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl);
      // update in repo
      await profileRepo.updateProfile(updatedProfile);
      // re-fetch user
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError(message: "Error Updating profile: ${e.toString()}"));
    }
  }

  //toggle follow
  Future<void> toggleFollow(String currentUserId, String targetId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetId);
      await fetchUserProfile(targetId);
    } catch (e) {
      emit(ProfileError(message: "Error in following.."));
    }
  }
}
