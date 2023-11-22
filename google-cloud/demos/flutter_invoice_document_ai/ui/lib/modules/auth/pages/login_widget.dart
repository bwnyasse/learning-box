import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

AuthBloc get authBloc => Modular.get<AuthBloc>();

class OnboardingPageConstants {
  static const String coverImageUrl = "images/login_background.jpg";
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(OnboardingPageConstants
                .coverImageUrl), // Replace with your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Welcome to Invoice DocumentAI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: Colors.black, // Text color
                  ),
                  icon: SvgPicture.asset(
                    "images/google.svg",
                    width: 16,
                  ),
                  label: const Text('Sign in with Google'),
                  onPressed: () async {
                    authBloc.add(AuthLoginWithGoogleEvent());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
