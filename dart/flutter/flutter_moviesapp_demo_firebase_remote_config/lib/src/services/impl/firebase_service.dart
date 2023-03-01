import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/impl/menuitem.dart';

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

// Configuration

  String getTermsAndConditions() => 
      firebaseRemoteConfig.getString('terms_and_conditions');

  bool isTitleCurrentPath() => firebaseRemoteConfig.getBool('title_current_path');

  bool isDemoDay() =>  false;
  // =>  firebaseRemoteConfig.getBool('demo_day');

  bool isMenuListEnabled() => false;
  // => firebaseRemoteConfig.getBool('menu_list_enabled');

  bool isLocationUsers() => false;
   // => firebaseRemoteConfig.getBool('location_users');

  bool isChartDetailEnabled() => true;
      // => firebaseRemoteConfig.getBool('chart_details_enabled');

  bool isTopRatedEnabled() => firebaseRemoteConfig.getBool('top_rated_enabled');

  bool isUpcomingEnabled() => firebaseRemoteConfig.getBool('upcoming_enabled');

  bool isGridMoviesEnabled() =>  firebaseRemoteConfig.getBool('grid_movies_enabled');

  MenuItemResponse getMenuItems() {
    final json = firebaseRemoteConfig.getString('menu_list');

    return MenuItemResponse.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}
