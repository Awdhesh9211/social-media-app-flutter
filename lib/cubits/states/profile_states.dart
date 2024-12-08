import 'package:mediasocial/entities/models/profile_user.dart';

abstract class ProfileStates {}

// initial
class ProfileInitial extends ProfileStates {}

// loading..
class ProfileLoading extends ProfileStates {}

// loaded
class ProfileLoaded extends ProfileStates {
  final ProfileUser profileUser;
  ProfileLoaded({required this.profileUser});
}

// error
class ProfileError extends ProfileStates {
  final String message;
  ProfileError({required this.message});
}
