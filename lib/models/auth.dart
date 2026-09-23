import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  static const String _loggedInKey = 'logged_in';
  final SharedPreferences _prefs;

  Auth(this._prefs);

  bool get loggedIn => _prefs.getBool(_loggedInKey) ?? false;

  Future<void> signIn(String username, String password) async {
    await _prefs.setBool(_loggedInKey, true);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _prefs.setBool(_loggedInKey, false);
    notifyListeners();
  }
}