import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/constants.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/cubits/cubit.dart';
import 'src/features/firebase/firebase_options.dart';
import 'src/providers/providers.dart';
import 'src/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firebaseRemoteConfigService = FirebaseRemoteConfigService(
    firebaseRemoteConfig: FirebaseRemoteConfig.instance,
  );
  await firebaseRemoteConfigService.init();

  Client client = Client();

  final locationService = LocationService(client);
  await locationService.load();

  runApp(AppProvider(
    httpClient: client,
    firebaseRemoteConfigService: firebaseRemoteConfigService,
    locationService: locationService,
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
      title: 'PoC Firebase Remote Config',
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
