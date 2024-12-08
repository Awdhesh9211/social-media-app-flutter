import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/entities/models/comment.dart';
import 'package:mediasocial/entities/models/post.dart';
import 'package:mediasocial/entities/repository/post_repo.dart';
import 'package:mediasocial/cubits/states/post_states.dart';
import 'package:mediasocial/entities/repository/storage_repo.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostInitial());

  // create a new Post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    try {
      String? imageUrl;
      // for mobile
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      // for web
      if (imageBytes != null) {
        emit(PostLoading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }
      // give image url
      final newPost = post.copyWith(imageUrl);

      // create a new Post
      postRepo.createPost(newPost);

      // refetch all post
      postRepo.fetchAllPosts();
    } catch (e) {
      emit(PostError(message: "Error while creating Post > $e"));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      print("Printing   $posts");
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: "Failed to fetch all  Post...> $e"));
    }
  }

  // delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError(message: "Error while Deleting: $e"));
    }
  }

  //  toggel likes
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostError(message: "Failed To toggle Likes: $e"));
    }
  }

  // add comment
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostError(message: "Error in comment : $e"));
    }
  }

  // delete Post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostError(message: "Error while deleting comment:$e"));
    }
  }
}
