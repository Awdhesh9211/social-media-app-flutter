import 'package:mediasocial/entities/models/post.dart';

abstract class PostStates {}

// imitial
class PostInitial extends PostStates {}

// loading
class PostLoading extends PostStates {}

// uploading
class PostUploading extends PostStates {}

// error
class PostError extends PostStates {
  final String message;
  PostError({required this.message});
}

// loaded
class PostLoaded extends PostStates {
  final List<Post> posts;
  PostLoaded({required this.posts});
}
