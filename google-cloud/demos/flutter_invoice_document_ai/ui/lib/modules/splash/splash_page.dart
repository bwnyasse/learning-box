import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../auth/pages/login_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    handleAuthNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF14181B),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.network(
              OnboardingPageConstants.coverImageUrl,
            ).image,
          ),
        ),
      ),
    );
  }
}
