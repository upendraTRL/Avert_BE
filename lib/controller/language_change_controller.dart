import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences
        .getInstance(); //Storing user's lang preferences locally

    _appLocale = type;

    print('MAIN FILE - $type');

    if (type == const Locale('hi')) {
      await sp.setString('lang_code', 'hi');
    } else if (type == const Locale('fr')) {
      await sp.setString('lang_code', 'fr');
    } else {
      await sp.setString('lang_code', 'en');
    }
  }
}
