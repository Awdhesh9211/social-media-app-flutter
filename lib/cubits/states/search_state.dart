import 'package:mediasocial/entities/models/profile_user.dart';

abstract class SearchState {}

// initial
class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ProfileUser?> users;
  SearchLoaded({required this.users});
}

class SearchError extends SearchState {
  final String message;
  SearchError({required this.message});
}
