import 'package:flutter/material.dart';
import 'package:mediasocial/pages/auth/login_page.dart';
import 'package:mediasocial/pages/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Initial Login
  bool showLoginPage = true;

  // toggle
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context)=>showLoginPage ? LoginPage(toggle: togglePage,) : RegisterPage(toggle: togglePage,);
}
