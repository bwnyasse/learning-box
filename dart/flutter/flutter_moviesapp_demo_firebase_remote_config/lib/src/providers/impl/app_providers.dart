import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';

///
/// My App Provider responsible to inject
/// Object as singleton
///
class AppProvider extends StatelessWidget {
  final Client httpClient;
  final Widget child;

  AppProvider({
    required this.httpClient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService(httpClient)),
      ],
      child: child,
    );
  }
}