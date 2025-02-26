import 'package:flutter/material.dart';
import 'package:wisefi/widget/main_layout.dart';

void main() {
  runApp(const WiseFiApp());
}

class WiseFiApp extends StatelessWidget {
  const WiseFiApp({Key? key}) : super(key: key);

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