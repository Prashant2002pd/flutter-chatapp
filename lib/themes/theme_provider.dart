import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test3/themes/light_mode.dart';
import 'package:test3/themes/dark_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ThemeProvider() {
    _initializeTheme();
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkmode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  Future<void> _initializeTheme() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _loadThemeFromFirebase();
    } else {
      _loadThemeFromSystem();
    }
  }

  Future<void> _loadThemeFromFirebase() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()!.containsKey('theme')) {
        String theme = userDoc.data()!['theme'];
        _themeData = theme == 'dark' ? darkmode : lightMode;
      } else {
        _themeData = lightMode;
      }
      notifyListeners();
    }
  }

  void _loadThemeFromSystem() {
    final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    _themeData = brightness == Brightness.dark ? darkmode : lightMode;
    notifyListeners();
  }

  Future<void> _updateThemeInFirebase() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'theme': _themeData == darkmode ? 'dark' : 'light',
      }, SetOptions(merge: true));
    }
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkmode : lightMode;
    _updateThemeInFirebase();
    notifyListeners();
  }
}