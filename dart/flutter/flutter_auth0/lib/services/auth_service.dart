import 'package:flutter/material.dart';

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

  /// -----------------------------------
  ///  2- instantiate secure storage
  /// -----------------------------------

  /// -----------------------------------
  ///  3- init
  /// -----------------------------------

  /// -----------------------------------
  ///  4- login
  /// -----------------------------------
  login() {
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
