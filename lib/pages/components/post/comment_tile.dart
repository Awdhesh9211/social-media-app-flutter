import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/entities/models/app_user.dart';
import 'package:mediasocial/cubits/auth_cubit.dart';
import 'package:mediasocial/entities/models/comment.dart';
import 'package:mediasocial/cubits/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  // current user
  AppUser? currentUser;
  bool isOwnComment = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnComment = (widget.comment.userId == currentUser!.uid);
  }

  // show deletion option
  void showOptions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Comment?"),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),

                // delete button
                TextButton(
                    onPressed: () {
                      context.read<PostCubit>().postRepo.deleteComment(
                          widget.comment.postId, widget.comment.id);
                      Navigator.pop(context);
                    },
                    child: const Text("Delete")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // name
          Text(
            widget.comment.userName,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(
            width: 10,
          ),
          // text
          Text(widget.comment.text),
          const Spacer(),

          // delete comment button
          if (isOwnComment)
            GestureDetector(
                onTap: showOptions,
                child: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).colorScheme.primary,
                ))
        ],
      ),
    );
  }
}
