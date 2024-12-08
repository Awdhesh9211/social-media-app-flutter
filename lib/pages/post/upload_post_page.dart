import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:mediasocial/entities/models/app_user.dart';
import 'package:mediasocial/pages/components/auth/my_text_field.dart';
import 'package:mediasocial/cubits/auth_cubit.dart';
import 'package:mediasocial/entities/models/post.dart';
import 'package:mediasocial/cubits/post_cubit.dart';
import 'package:mediasocial/cubits/states/post_states.dart';
import 'package:mediasocial/pages/responsive/constrained_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile pic image
  PlatformFile? imagePickedFile;

  // web image pic
  Uint8List? webImage;

  // text controller
  final textController = TextEditingController();

  // current user
  AppUser? currentUser;

  Future<void> pickImage() async {
// Request storage permissions
    if (await Permission.storage.request().isGranted) {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: kIsWeb,
        );
        print(result!.files.first);
        if (result != null) {
          setState(() {
            imagePickedFile = result.files.first;
          });
          if (kIsWeb) {
            webImage = imagePickedFile!.bytes;
          }
        }
      } catch (e) {
        print("Storage permission denied");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // create & upload post
  void uploadPost() {
    // check if both image and cation
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Provide Both Fields...")));
      return;
    }

    // create a new post object
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // post cubit
    final postCubit = context.read<PostCubit>();

    // web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }

    // mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(builder: (context, postState) {
      // loading or uploading
      if (postState is PostLoading || postState is PostUploading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // build upload page
      return buildUploadPage();
    }, listener: (context, postState) {
      if (postState is PostLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildUploadPage() {
    return ConstrainedScaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload))
        ],
      ),

      // BODY
      body: Center(
        child: Column(
          children: [
            // image preveive for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            // image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            // pick image Button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.green,
              child: const Text("Pick Image"),
            ),

            // caption textbox
            MyTextField(
                controller: textController,
                hintText: "Enter Caption ",
                obscureText: false)
          ],
        ),
      ),
    );
  }
}
