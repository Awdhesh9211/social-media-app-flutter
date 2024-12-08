import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediasocial/entities/models/app_user.dart';
import 'package:mediasocial/cubits/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/cubits/post_cubit.dart';
import 'package:mediasocial/cubits/states/post_states.dart';
import 'package:mediasocial/pages/components/post/post_tile.dart';
import 'package:mediasocial/pages/components/profile/bio_box.dart';
import 'package:mediasocial/pages/components/profile/follow_buttton.dart';
import 'package:mediasocial/pages/components/profile/profile_stats.dart';
import 'package:mediasocial/cubits/profile_cubit.dart';
import 'package:mediasocial/cubits/states/profile_states.dart';
import 'package:mediasocial/pages/profile/edit_profile_page.dart';
import 'package:mediasocial/pages/profile/follower_page.dart';
import 'package:mediasocial/pages/responsive/constrained_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // auth cubit
  late final authCubit = context.read<AuthCubit>();
  // profile cubit
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;


  // start up
  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  void fetchProfile() {
    print("fetch");
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    // my profile
    bool isOwnProfile = widget.uid == currentUser!.uid;

    //  FOLLOW/UNFOLLOW
    void followButtonPressed() {
      final profileState = profileCubit.state;
      if (profileState is! ProfileLoaded) {
        return;
      }
      final profileUser = profileState.profileUser;
      final isFollowing = profileUser.followers.contains(currentUser!.uid);

      // Optimal update
      setState(() {
        // unfollow
        if (isFollowing) {
          profileUser.followers.remove(currentUser!.uid);
        } else {
          profileUser.followers.add(currentUser!.uid);
        }
      });

      profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((err) {
        // unfollow
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        } else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    }

    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, profileState) {
        print(profileState);
        //loaded
        if (profileState is ProfileLoaded) {
          // get user
          final user = profileState.profileUser;

          return ConstrainedScaffold(
              // APPBAR
              appBar: AppBar(
                title: Text(currentUser!.name),
                foregroundColor: Theme.of(context).colorScheme.primary,
                actions: [
                  // edit profile
                  if (isOwnProfile)
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditProfilePage(user: user))),
                        icon: const Icon(Icons.edit))
                ],
              ),
              // BODY
              body: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: ListView(
                    children: [
                      // Email
                      Center(
                        child: Text(
                          user.email,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      // Profile Pic
                      CachedNetworkImage(
                        imageUrl: user.profileImageUrl,
                        // loading
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),

                        //err
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 72,
                          color: Theme.of(context).colorScheme.primary,
                        ),

                        // loaded
                        imageBuilder: (context, imageProvider) => Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      // profileStates
                      ProfileStats(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => FollowerPage(
                                      followers: user.followers,
                                      following: user.following))),
                          postCount: postCount,
                          followerCount: user.followers.length,
                          followingCount: user.following.length),

                      // follow button
                      if (!isOwnProfile)
                        FollowButtton(
                            onPressed: followButtonPressed,
                            isFollowing:
                                user.followers.contains(currentUser!.uid)),

                      // bio box
                      Row(
                        children: [
                          Text(
                            "Bio",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BioBox(text: user.bio),

                      // post
                      // bio box
                      Row(
                        children: [
                          Text(
                            "Posts",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // List of posts for this user
                      BlocBuilder<PostCubit, PostStates>(
                        builder: (context, state) {
                          // post loaded
                          if (state is PostLoaded) {
                            final userPost = state.posts
                                .where((post) => post.userId == widget.uid)
                                .toList();
                            postCount = userPost.length;

                            return ListView.builder(
                                itemCount: postCount,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final post = userPost[index];
                                  return PostTile(
                                      post: post,
                                      onDeletePressed: () => context
                                          .read<PostCubit>()
                                          .deletePost(post.id));
                                });
                          }

                          // loading
                          else if (state is PostLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Center(
                              child: Text("No Post..."),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )

              //
              );
        } // loading...
        else if (profileState is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        //Error
        else if (profileState is ProfileError) {
          return const Center(
            child: Text("Error: "),
          );
        } else {
          return const Center(
            child: Text("Profile is Not Found"),
          );
        }
      },
    );
  }
}
