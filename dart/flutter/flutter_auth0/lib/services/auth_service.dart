import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../helpers/constants.dart';

class _LoginInfo extends ChangeNotifier {
  var _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}

/// -----------------------------------
///   Auth0 environment variables
/// -----------------------------------

/// -----------------------------------
///  Auth Service Singleton
/// -----------------------------------
class AuthService {
  static final AuthService instance = AuthService._internal();

  factory AuthService() {
    return instance;
  }

  AuthService._internal();

  final _loginInfo = _LoginInfo();

  get loginInfo => _loginInfo;

  /// -----------------------------------
  ///  1- instantiate appAuth
  /// -----------------------------------
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  /// -----------------------------------
  ///  2- instantiate secure storage
  /// -----------------------------------

  /// -----------------------------------
  ///  3- init
  /// -----------------------------------

  /// -----------------------------------
  ///  4- login
  /// -----------------------------------

  login() async {
    final authorizationTokenRequest = AuthorizationTokenRequest(
      AUTH0_CLIENT_ID,
      AUTH0_REDIRECT_URI,
      issuer: AUTH0_ISSUER,
      scopes: [
        'openid',
        'profile',
        'offline_access',
        'email',
      ],
    );

    final AuthorizationTokenResponse? result =
        await appAuth.authorizeAndExchangeCode(
      authorizationTokenRequest,
    );

    print(result);
    _loginInfo.isLoggedIn = true;
  }

  /// -----------------------------------
  ///  5- setProfileAndIdToken
  /// -----------------------------------

  /// -----------------------------------
  ///  6- logout
  /// -----------------------------------
  logout() {
    _loginInfo.isLoggedIn = false;
  }

  /// -----------------------------------
  ///  7- parseIdToken
  /// -----------------------------------

  /// -----------------------------------
  ///  8- getUserDetails
  /// -----------------------------------

  /// -----------------------------------
  ///  9- availableCustomerService
  /// -----------------------------------

}
