import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/firebase/firebase_auth_repo.dart';
import 'package:mediasocial/cubits/auth_cubit.dart';
import 'package:mediasocial/cubits/states/auth_state.dart';
import 'package:mediasocial/pages/auth/auth_page.dart';
import 'package:mediasocial/pages/home/home_page.dart';
import 'package:mediasocial/firebase/firebase_post_repo.dart';
import 'package:mediasocial/cubits/post_cubit.dart';
import 'package:mediasocial/firebase/firebase_profile_repo.dart';
import 'package:mediasocial/cubits/profile_cubit.dart';
import 'package:mediasocial/firebase/firebase_search_repo.dart';
import 'package:mediasocial/cubits/search_cubit.dart';
import 'package:mediasocial/firebase/firebase_storage_repo.dart';
import 'package:mediasocial/cubits/theme_cubit.dart';

/*

APP- Root Level

Repositories for the database 
    -Firebase

Bloc Provider: State management
    -auth
    -profile
    -post
    -search
    -theme

Check Auth state 
    -unauthenticated -> (login/register )
    -authenticated -> home page 

  */

class MyApp extends StatelessWidget {
  // Repository
  final authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();
  final storageRepo = FirebaseStorageRepo();
  final postRepo = FirebasePostRepo();
  final searchRepo = FirebasesearchRepo();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
// Provide cubit to app

    return MultiBlocProvider(
        // Provider
        providers: [
          // Auth Cubit
          BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(authRepo: authRepo)..checkAuth()),

          // Profile Cubit
          BlocProvider<ProfileCubit>(
              create: (context) => ProfileCubit(
                  profileRepo: profileRepo, storageRepo: storageRepo)),

          // Post Cubit
          BlocProvider<PostCubit>(
              create: (context) =>
                  PostCubit(postRepo: postRepo, storageRepo: storageRepo)),

          // search Cubit
          BlocProvider<SearchCubit>(
              create: (context) => SearchCubit(searchRepo: searchRepo)),

          // theme Cubit
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        ],
        // Initial Execution
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, currentTheme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: currentTheme,
            home: BlocConsumer<AuthCubit, AuthState>(
              builder: (context, authState) {
                print(authState);
                // unauthenticated
                if (authState is Unauthenticated) {
                  return const AuthPage();
                }
                // authenticated
                if (authState is Authenticated) {
                  return HomePage();
                }

                // Loading..
                else {
                   return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                }
              },
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),
          ),
        ));
  }
}
