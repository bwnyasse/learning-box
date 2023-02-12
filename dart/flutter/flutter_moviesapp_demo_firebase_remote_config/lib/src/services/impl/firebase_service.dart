import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  const FirebaseRemoteConfigService({
    required this.firebaseRemoteConfig,
  });

  final FirebaseRemoteConfig firebaseRemoteConfig;

  Future<void> init() async {
    try {
      await firebaseRemoteConfig.ensureInitialized();
      await firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await firebaseRemoteConfig.fetchAndActivate();
    } on FirebaseException catch (e, st) {
      developer.log(
        'Unable to initialize Firebase Remote Config',
        error: e,
        stackTrace: st,
      );
    }
  }

  bool getLocationUsers() => firebaseRemoteConfig.getBool('location_users');
  
  bool getChartDetailEnabled() =>
      firebaseRemoteConfig.getBool('chart_details_enabled');

  bool getTopRatedEnabled() =>
      firebaseRemoteConfig.getBool('top_rated_enabled');

  bool getUpcomingEnabled() => firebaseRemoteConfig.getBool('upcoming_enabled');

  bool getGridMoviesEnabled() => firebaseRemoteConfig.getBool('grid_movies_enabled');
  
}
