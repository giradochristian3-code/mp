import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionModel with ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  String _token = '';

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get token => _token;

  Future<void> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _username = prefs.getString('username') ?? '';
    _token = prefs.getString('token') ?? '';
    notifyListeners();
  }

  Future<void> saveSession(String username, {String token = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
    await prefs.setString('token', token);
    _isLoggedIn = true;
    _username = username;
    _token = token;
    notifyListeners();
  }

  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');
    await prefs.remove('token');
    _isLoggedIn = false;
    _username = '';
    _token = '';
    notifyListeners();
  }
}