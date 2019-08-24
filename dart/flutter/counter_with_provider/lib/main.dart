import 'package:counter_with_provider/i18n/localization.dart';
import 'package:counter_with_provider/provider/counter.dart';
import 'package:counter_with_provider/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => Counter()),
      ],
      child: Consumer<Counter>(
        builder: (context, counter, _) {
          return MaterialApp(
            supportedLocales: const [Locale('en')],
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              ExampleLocalizationsDelegate(counter.count),
            ],
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}