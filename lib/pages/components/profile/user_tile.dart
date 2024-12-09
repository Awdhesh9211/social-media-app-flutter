import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediasocial/entities/models/profile_user.dart';
import 'package:mediasocial/firebase/firebase_auth_repo.dart';
import 'package:mediasocial/firebase/firebase_search_repo.dart';
import 'package:mediasocial/pages/profile/profile_page.dart';

class UserTile extends StatefulWidget {
  final ProfileUser user;
  const UserTile({super.key, required this.user});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final FirebasesearchRepo _searchRepo = FirebasesearchRepo();

  // Function to handle onTap, fetch document ID, and navigate
  Future<void> _handleTap() async {
    try {
      print("Search user by email...");
      // Retrieve the document ID based on the user's email
      String? docId = await _searchRepo.getUidByEmail(widget.user.email);

      if (docId != null) {
        // If a document ID is found, navigate to the ProfilePage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => ProfilePage(
              uid:
                  docId, // Pass the user's uid        // Pass the retrieved document ID
            ),
          ),
        );
      } else {
        // If no document found, you can show a message or handle it as needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User document not found")),
        );
      }
    } catch (e) {
      // Handle any errors (e.g., failed to fetch docId)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user document ID")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.user.name),
      subtitle: Text(widget.user.email),
      subtitleTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary),
      leading: widget.user.profileImageUrl.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(widget.user.profileImageUrl),
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
      onTap: _handleTap, // Use the new _handleTap method
    );
  }
}
