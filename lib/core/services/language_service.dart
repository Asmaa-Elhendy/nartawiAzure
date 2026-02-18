import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static final ValueNotifier<Locale?> _localeNotifier = ValueNotifier<Locale?>(null);
  
  static ValueNotifier<Locale?> get localeNotifier => _localeNotifier;
  
  static Locale? get currentLocale => _localeNotifier.value;
  
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selected_language');
    
    if (savedLanguage != null) {
      _localeNotifier.value = Locale(savedLanguage);
    }
  }
  
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
    _localeNotifier.value = Locale(languageCode);
  }
  
  static Future<void> setSystemLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_language');
    _localeNotifier.value = null;
  }
  
  static bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }
  
  static bool isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }
}
