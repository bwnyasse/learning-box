import 'package:flutter_moviesapp_demo_firebase_remote_config/src/constants.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/cubits/cubit.dart';
import 'src/providers/impl/app_providers.dart';
import 'src/services/services.dart';

void main() {
  runApp(AppProvider(
    httpClient: Client(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ApiService apiService = context.watch<ApiService>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter MoviesApp Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: BlocProvider(
          create: (context) => AppCubit(
                service: apiService,
              ),
          child: const MainScreen()),
    );
  }
}
