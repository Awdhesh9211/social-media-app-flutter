import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/pages/components/auth/my_text_field.dart';
import 'package:mediasocial/entities/models/profile_user.dart';
import 'package:mediasocial/cubits/profile_cubit.dart';
import 'package:mediasocial/cubits/states/profile_states.dart';
import 'package:mediasocial/pages/responsive/constrained_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image pic
  PlatformFile? imagePickedFile;

  // web image pic
  Uint8List? webImage;

// pick image
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

  TextEditingController bioController = TextEditingController();

  // upload profile
  void updateProfile() async {
    print("update Profile...");

    // profile Cubit
    final profileCubit = context.read<ProfileCubit>();

    // prepare image and data
    //id
    final String uid = widget.user.uid;
    //image
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    //bio
    final String? newBio =
        bioController.text.isNotEmpty ? bioController.text : null;

    print("IMAGE== $imageMobilePath Bio== $newBio");

    if (imagePickedFile != null || newBio != null) {
      print("YO GET THE IMAGE ...");
      Navigator.pop(context);
      profileCubit.updateProfile(
          uid: uid,
          newBio: newBio,
          imageMobilepath: imageMobilePath,
          imageWebBytes: imageWebBytes);
    }
    // do nothing
    else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold
    return BlocConsumer<ProfileCubit, ProfileStates>(
        builder: (context, profileStates) {
      // loading
      if (profileStates is ProfileLoading) {
        return const Scaffold(
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              Text("Uploading...."),
            ]),
          ),
        );
      } else {
        // edit form
        return buildEditPage();
      }
    }, listener: (context, profileStates) {
      if (profileStates is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildEditPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Edit Your Profile..."),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: updateProfile, icon: const Icon(Icons.upload))
        ],
      ),
      body: Column(
        children: [
          // profil pic
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,
              child:
                  // display selected image for mobile
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                          File(
                            imagePickedFile!.path!,
                          ),
                          fit: BoxFit.cover)
                      // display selected image for web
                      : (kIsWeb && webImage != null)
                          ? Image.memory(
                              webImage!,
                              fit: BoxFit.cover,
                            )
                          :
                          // no image selected existing profile
                          CachedNetworkImage(
                              imageUrl: widget.user.profileImageUrl,
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
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.green,
              child: const Text('Select Image'),
            ),
          ),

          // bio
          const Text("Bio"),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
                controller: bioController,
                hintText: widget.user.bio,
                obscureText: false),
          )
        ],
      ),
    );
  }
}
