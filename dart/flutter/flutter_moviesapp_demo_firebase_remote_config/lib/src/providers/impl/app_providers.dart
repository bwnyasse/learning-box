library providers;

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
  final FirebaseService firebaseRemoteConfigService;

  final LocationService locationService;

  const AppProvider({
    super.key,
    required this.httpClient,
    required this.child,
    required this.firebaseRemoteConfigService,
    required this.locationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService(httpClient)),
        Provider<LocationService>(create: (_) => locationService),
        Provider<FirebaseService>(
            create: (_) => firebaseRemoteConfigService),
      ],
      child: child,
    );
  }
}
