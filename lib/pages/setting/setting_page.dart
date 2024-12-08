import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/pages/responsive/constrained_scaffold.dart';
import 'package:mediasocial/cubits/theme_cubit.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    // theme cubit
    final themeCubit = context.watch<ThemeCubit>();

    // is Dark mode
    bool isDarkMode = themeCubit.isDarkMode;

    return ConstrainedScaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text("Setting"),
      ),

      body: Column(
        children: [
          // dark mode title
          ListTile(
            title:const Text("Dark Mode"),
            trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value) {
                  themeCubit.toggleTheme();
                }),
          ),
        ],
      ),
    );
  }
}
