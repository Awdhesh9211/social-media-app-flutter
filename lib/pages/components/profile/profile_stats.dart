import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats(
      {super.key,
      required this.postCount,
      required this.followerCount,
      required this.followingCount,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    //  style
    var count = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);
    var hint = TextStyle(color: Theme.of(context).colorScheme.primary);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // post count
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  postCount.toString(),
                  style: count,
                ),
                Text(
                  "Posts",
                  style: hint,
                )
              ],
            ),
          ),
      
          // followers count
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followerCount.toString(), style: count),
                Text(
                  "Followers",
                  style: hint,
                )
              ],
            ),
          ),
      
          // following countv
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(), style: count),
                Text(
                  "Following",
                  style: hint,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
