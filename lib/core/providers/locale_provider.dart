import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  // default to system locale
  Locale? _locale;

  Locale? get locale => _locale;

  // Called by MaterialApp via provider
  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }

  // Reset to system/local default
  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
