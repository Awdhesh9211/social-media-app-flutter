import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FollowButtton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;
  const FollowButtton(
      {super.key, required this.onPressed, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          padding: const EdgeInsets.all(20),
          onPressed: onPressed,
          color: isFollowing
              ? Theme.of(context).colorScheme.primary
              : Colors.blueAccent,
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ),
    );
  }
}
