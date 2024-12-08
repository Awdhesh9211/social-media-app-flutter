import 'package:flutter/material.dart';
import 'package:mediasocial/pages/components/auth/my_button.dart';
import 'package:mediasocial/pages/components/auth/my_text_field.dart';
import 'package:mediasocial/cubits/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/pages/responsive/constrained_scaffold.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? toggle;
  const RegisterPage({super.key, required this.toggle});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();

  void signup() {
    // prepare email & pass
    final String name = nameController.text;
    final String email = emailController.text;
    final String pass = passController.text;
    final String cPass = confirmPwController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure email & pass is not empty
    if (email.isNotEmpty &&
        pass.isNotEmpty &&
        name.isNotEmpty &&
        cPass.isNotEmpty) {
      if (pass == cPass) {
        authCubit.register(name, email, pass);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password Doesn't Match...")));
      }
    }
    // else error
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All Fields are required...")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      // body
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          margin: EdgeInsets.only(top: 10),
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
                "Lets create account for you...",
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
                prefixIcon: Icons.person,
                  controller: nameController,
                  hintText: "Name...",
                  obscureText: false),
              const SizedBox(
                height: 10,
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
                height: 10,
              ),

              // confirm pw textField
              MyTextField(
                prefixIcon: Icons.password,
                  controller: confirmPwController,
                  hintText: "Confirm Password...",
                  obscureText: true),

              const SizedBox(
                height: 25,
              ),

              // Signup btn
              MyButton(onTap: signup, text: "Sign Up"),
              const SizedBox(
                height: 50,
              ),

              // not a member go to the register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.toggle,
                    child: Text(
                      "Log In",
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
