import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/entities/models/app_user.dart';
import 'package:mediasocial/pages/components/auth/my_text_field.dart';
import 'package:mediasocial/cubits/auth_cubit.dart';
import 'package:mediasocial/entities/models/comment.dart';
import 'package:mediasocial/entities/models/post.dart';
import 'package:mediasocial/cubits/post_cubit.dart';
import 'package:mediasocial/cubits/states/post_states.dart';
import 'package:mediasocial/pages/components/post/comment_tile.dart';
import 'package:mediasocial/entities/models/profile_user.dart';
import 'package:mediasocial/cubits/profile_cubit.dart';
import 'package:mediasocial/pages/profile/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    Key? key,
    required this.post,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;

  final commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((err) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a new Comment .."),
        content: MyTextField(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void addComment() {
    final newComment = Comment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => ProfilePage(uid: widget.post.userId)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          height: 20,
                          width: 20,
                          imageUrl: postUser!.profileImageUrl,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                        )
                      : const Icon(Icons.person),
                  const SizedBox(width: 10),
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showOptions,
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                ],
              ),
            ),
            CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(height: 430),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: toggleLikePost,
                          child: widget.post.likes.contains(currentUser!.uid)
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(Icons.favorite_border),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.post.likes.length.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: openNewCommentBox,
                    child: Icon(Icons.comment,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(widget.post.comments.length.toString()),
                  const Spacer(),
                  Text(widget.post.timestamp.toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Text(
                    widget.post.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.post.text),
                ],
              ),
            ),
            BlocBuilder<PostCubit, PostStates>(
              bloc: postCubit,
              builder: (context, state) {
                if (state is PostLoaded) {
                  final post =
                      state.posts.firstWhere((p) => p.id == widget.post.id);
                  if (post.comments.isNotEmpty) {
                    return ListView.builder(
                      itemCount: post.comments.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final comment = post.comments[index];
                        return CommentTile(comment: comment);
                      },
                    );
                  }
                }

                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PostError) {
                  return const Center(child: Text("Error loading comments"));
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
