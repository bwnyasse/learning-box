import 'package:flutter/material.dart';
import 'package:wisefi/widget/main_layout.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WiseFiApp());
}

class WiseFiApp extends StatelessWidget {
  const WiseFiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiseFi by Dev Datavalet ( POC )',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1a1a1a),
        cardTheme: CardTheme(
          color: const Color(0xFF2a2a2a),
          elevation: 3,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF3a3a3a),
        ),
      ),
      home: const MainLayout(),
    );
  }
}
