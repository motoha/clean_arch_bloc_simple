import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider with ChangeNotifier {
  static const String _tokenKey = 'token';
  String? _token;

  String? get token => _token;

  TokenProvider() {
    _loadToken(); // Load the token during initialization
  }

  Future<void> setToken(String? token) async {
    _token = token;
    notifyListeners();

    // Save the token to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    } else {
      await prefs.remove(_tokenKey); // Clear token if null
    }
  }

  Future<void> clearToken() async {
    _token = null;
    notifyListeners();

    // Remove the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> _loadToken() async {
    // Load the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    notifyListeners();
  }
}
