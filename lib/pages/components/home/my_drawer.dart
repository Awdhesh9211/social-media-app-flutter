import 'package:flutter/material.dart';
import 'package:mediasocial/cubits/auth_cubit.dart';
import 'package:mediasocial/pages/components/home/my_drawer_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/pages/profile/profile_page.dart';
import 'package:mediasocial/pages/search/search_page.dart';
import 'package:mediasocial/pages/setting/setting_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Icon(Icons.person,
                    size: 80, color: Theme.of(context).colorScheme.primary),
              ),

              // diveder line
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              // Home Tile
              MyDrawerTile(
                  icon: Icons.home,
                  title: "H O M E",
                  onTap: () => Navigator.of(context).pop()),

              // Profile tile
              MyDrawerTile(
                  icon: Icons.person,
                  title: "P R O F I L E",
                  onTap: () {
                    Navigator.of(context).pop();
                    final user = context.read<AuthCubit>().currentUser;
                    String? uid = user!.uid;
                    print(uid);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ProfilePage(
                                  uid: uid,
                                )));
                  }),

              // search Tile
              MyDrawerTile(
                  icon: Icons.search,
                  title: "S E A R C H",
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const SearchPage()));
                  }),

              // Setting Tile
              MyDrawerTile(
                  icon: Icons.settings,
                  title: "S E T T I N G",
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const SettingPage()));
                  }),

              // spacing
              const Spacer(),

              // Logout Tile
              MyDrawerTile(
                  icon: Icons.logout,
                  title: "L O G O U T",
                  onTap: () {
                    Navigator.of(context).pop();
                    context.read<AuthCubit>().logout();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
