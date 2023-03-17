import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../helpers/constants.dart';
import '../models/auth0_id_token.dart';
import '../models/auth0_user.dart';

typedef AsyncCallbackString = Future<String> Function();

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

  Auth0User? profile;
  Auth0IdToken? idToken;
  String? auth0AccessToken;

  /// -----------------------------------
  ///  1- instantiate appAuth
  /// -----------------------------------
  final FlutterAppAuth appAuth = FlutterAppAuth();

  /// -----------------------------------
  ///  2- instantiate secure storage
  /// -----------------------------------
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  /// -----------------------------------
  ///  3- init
  /// -----------------------------------
  Future<String> init() async {
    return errorHandler(() async {
      final storedRefreshToken = await secureStorage.read(
        key: REFRESH_TOKEN_KEY,
      );

      if (storedRefreshToken == null) {
        return 'You need to login';
      }

      final TokenResponse? result = await appAuth.token(
        TokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: AUTH0_ISSUER,
          refreshToken: storedRefreshToken,
        ),
      );
      return _setLocalVariables(result);
    });
  }

  /// -----------------------------------
  ///  4- login
  /// -----------------------------------

  bool _isAuthResultValid(result) {
    return result != null &&
        result.accessToken != null &&
        result.idToken != null;
  }

  Future<String> _setLocalVariables(result) async {
    if (_isAuthResultValid(result)) {
      auth0AccessToken = result.accessToken;
      idToken = parseIdToken(result.idToken!);

      if (result.refreshToken != null) {
        await secureStorage.write(
          key: REFRESH_TOKEN_KEY,
          value: result.refreshToken,
        );
      }

      _loginInfo.isLoggedIn = true;

      return 'Success';
    } else {
      return 'Something is Wrong!';
    }
  }

  Future<String> errorHandler(AsyncCallbackString callback) async {
    try {
      return await callback();
    } on PlatformException catch (e) {
      return e.message ?? 'Something is Wrong! Code: ${e.code}';
    } catch (e, s) {
      print('Login Uknown erorr $e, $s');
      return 'Unkown Error ${e.runtimeType}';
    }
  }

  Future<String> login() async {
    return errorHandler(() async {
      final authorizationTokenRequest = AuthorizationTokenRequest(
        AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        scopes: [
          'openid',
          'profile',
          'offline_access',
          'email',
        ],
        promptValues: [
          'login'
        ], // force the user to login if the refreshtoken doesn't exist
      );

      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        authorizationTokenRequest,
      );

      return await _setLocalVariables(result);
    });
  }

  /// -----------------------------------
  ///  5- setProfileAndIdToken
  /// -----------------------------------

  /// -----------------------------------
  ///  6- logout
  /// -----------------------------------
  Future<void> logout() async {
    await secureStorage.delete(key: REFRESH_TOKEN_KEY);
    final sessionRequest = EndSessionRequest(
        idTokenHint: jsonEncode(idToken!.toJson()),
        issuer: AUTH0_ISSUER,
        postLogoutRedirectUrl: '$BUNDLE_IDENTIFIER:/');
    await appAuth.endSession(sessionRequest);
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
