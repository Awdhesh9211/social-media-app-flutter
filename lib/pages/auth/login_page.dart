import 'package:flutter/material.dart';
import 'package:mediasocial/pages/components/auth/my_button.dart';
import 'package:mediasocial/pages/components/auth/my_text_field.dart';
import 'package:mediasocial/cubits/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/pages/responsive/constrained_scaffold.dart';

class LoginPage extends StatefulWidget {
  final void Function()? toggle;
  const LoginPage({
    super.key,
    required this.toggle,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void login() {
    // prepare email & pass
    final String email = emailController.text;
    final String pass = passController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure email & pass is not empty
    if (email.isNotEmpty && pass.isNotEmpty) {
      print(email + "" + pass);
      authCubit.login(email, pass);
    }
    // else error
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter Email and Password...")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      // body
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              // logo
              Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),

              // Welcome back message
              Text(
                "Welcome back,you've been missed!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 25,
              ),

              // email textField
              MyTextField(
                  prefixIcon: Icons.email,
                  controller: emailController,
                  hintText: "Email...",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),

              // pw textField
              MyTextField(
                  prefixIcon: Icons.password,
                  controller: passController,
                  hintText: "Password...",
                  obscureText: true),
              const SizedBox(
                height: 25,
              ),

              // login btn
              MyButton(onTap: login, text: "Log In"),
              const SizedBox(
                height: 50,
              ),

              // not a member go to the register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a Member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.toggle,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
