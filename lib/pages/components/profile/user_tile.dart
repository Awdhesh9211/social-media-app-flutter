import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediasocial/entities/models/profile_user.dart';
import 'package:mediasocial/pages/profile/profile_page.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        subtitleTextStyle:
            TextStyle(color: Theme.of(context).colorScheme.primary),
        leading: user.profileImageUrl.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(user.profileImageUrl),
                backgroundColor: Colors.transparent,
              )
            : CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ProfilePage(uid: user.uid))),
            });
  }
}
