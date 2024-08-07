import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

import 'login_widget.dart';

AuthBloc get authBloc => Modular.get<AuthBloc>();

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      child: const LoginWidget(),
      listener: (context, state) {
        if (state is AuthFailedState) {
          AsukaSnackbar.warning("AuthFailedState").show();
        }
        if (state is AuthErrorState) {
          AsukaSnackbar.alert("AuthFailedState").show();
        }
        if (state is AuthSuccessState) {
          AsukaSnackbar.success("Log in Invoice DocumentAI").show();
        }
      },
    );
  }
}
