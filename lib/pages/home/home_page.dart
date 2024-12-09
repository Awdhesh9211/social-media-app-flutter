import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:mediasocial/cubits/post_cubit.dart';
import 'package:mediasocial/cubits/states/post_states.dart';
import 'package:mediasocial/pages/components/home/my_drawer.dart';
import 'package:mediasocial/pages/components/post/post_tile.dart';
import 'package:mediasocial/pages/post/upload_post_page.dart';
import 'package:mediasocial/pages/responsive/constrained_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PostCubit postCubit;

  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>(); // Access PostCubit here
    fetchAllPosts();
  }

  void fetchAllPosts() {
    print("Fetching posts...");
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Home"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UploadPostPage()),
            ),
            icon: Icon(Icons.upload,
                color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: BlocBuilder<PostCubit, PostStates>(
        builder: (context, postStates) {
          if (postStates is PostInitial) {
            postCubit.fetchAllPosts(); // Only fetch if in initial state
          }

          if (postStates is PostLoading || postStates is PostUploading) {
            postCubit.fetchAllPosts(); 
            return const Center(child: Text("Loading posts..."));
          }

          if (postStates is PostLoaded) {
            final allPosts = postStates.posts;

            if (allPosts.isEmpty) {
              return const Center(child: Text("No Posts available.."));
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                final post = allPosts[index];

                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              },
            );
          }

          return const SizedBox(); // Handle other states if necessary
        },
      ),
    );
  }
}
