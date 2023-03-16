import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/impl/menuitem.dart';

class FirebaseService {
  const FirebaseService({
    required this.analytics,
    required this.remoteConfig,
  });

  final FirebaseRemoteConfig remoteConfig;

  final FirebaseAnalytics analytics;

  Future<void> init() async {
    try {
      await remoteConfig.ensureInitialized();
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await remoteConfig.fetchAndActivate();
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
      remoteConfig.getString('terms_and_conditions');

  bool isTitleCurrentPath() => remoteConfig.getBool('title_current_path');

  bool isDemoDay() => false;
  // =>  firebaseRemoteConfig.getBool('demo_day');

  bool isMenuListEnabled() => false;
  // => firebaseRemoteConfig.getBool('menu_list_enabled');

  bool isLocationUsers() => false;
  // => firebaseRemoteConfig.getBool('location_users');

  bool isChartDetailEnabled() => true;
  // => firebaseRemoteConfig.getBool('chart_details_enabled');

  bool isTopRatedEnabled() => remoteConfig.getBool('top_rated_enabled');

  bool isUpcomingEnabled() => remoteConfig.getBool('upcoming_enabled');

  bool isGridMoviesEnabled() => remoteConfig.getBool('grid_movies_enabled');

  MenuItemResponse getMenuItems() {
    final json = remoteConfig.getString('menu_list');

    return MenuItemResponse.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}
