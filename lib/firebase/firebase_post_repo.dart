import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediasocial/entities/models/comment.dart';
import 'package:mediasocial/entities/models/post.dart';
import 'package:mediasocial/entities/repository/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postSnapshot =
          await postCollection.orderBy('timestamp', descending: true).get();
      final List<Post> allPost = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPost;
    } catch (e) {
      throw Exception("Error While Fetching all post ...> $e");
    }
  }
  

  @override
  Future<void> createPost(Post post) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error While Creating a post...> $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("Error While Deleting a post...> $e");
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      final postsSnapshot =
          await postCollection.where('userId', isEqualTo: userId).get();
      // json to Posts
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception("Error While fetching user post...> $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      // get post doc
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        // check if
        final hasliked = post.likes.contains(userId);

        //update the like list
        if (hasliked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        // update
        await postCollection.doc(postId).update({
          'likes': post.likes,
        });
      } else {
        throw Exception("Post Not Found...");
      }
    } catch (e) {
      throw Exception("Error in likes: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      // get Post doc
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        // convert to object
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add new comment
        post.comments.add(comment);

        // update the post document in firestore
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post Not Found...");
      }
    } catch (e) {
      throw Exception("Error in comment: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async{
     try {
      // get Post doc
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        // convert to object
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add new comment
        post.comments.removeWhere((comment)=>comment.id == commentId);

        // update the post document in firestore
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post Not Found...");
      }
    } catch (e) {
      throw Exception("Error in comment deletion: $e");
    }
  }
}
