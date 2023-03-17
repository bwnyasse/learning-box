import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../helpers/constants.dart';
import '../models/auth0_id_token.dart';

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

    final idToken = parseIdToken(result!.idToken!);
    print(idToken);
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
  Auth0IdToken parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    );

    return Auth0IdToken.fromJson(json);
  }

  /// -----------------------------------
  ///  8- getUserDetails
  /// -----------------------------------

  /// -----------------------------------
  ///  9- availableCustomerService
  /// -----------------------------------

}
