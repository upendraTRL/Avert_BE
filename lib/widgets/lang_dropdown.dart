import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangDropdown extends StatefulWidget {
  const LangDropdown({super.key});

  @override
  State<LangDropdown> createState() => _LangDropdownState();
}

class _LangDropdownState extends State<LangDropdown> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  late String _pastLocale;
  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    super.initState();

    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
  }

  //User address shared pref
  Future<void> _storeLangCode(
      String pastLangCode, String currentLangCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('isChanged', 'true');

    await prefs.setString('pastLangCode', pastLangCode);
    await prefs.setString('currentLangCode', currentLangCode);

    log('Updated Lang Code Stored');
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _currentLocale,
      icon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Icon(Icons.translate),
      ),
      onChanged: (value) {
        _pastLocale = _currentLocale;
        _setLocale(value);
        _storeLangCode(_pastLocale, _currentLocale);

        setState(() {
          // _currentLocale = newValue!;
        });
      },
      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: 'hi',
          child: Text('हिंदी'),
        ),
        DropdownMenuItem(
          value: 'mr',
          child: Text('मराठी'),
        ),
        DropdownMenuItem(
          value: 'gu',
          child: Text('ગુજરાતી'),
        ),
        DropdownMenuItem(
          value: 'te',
          child: Text('తెలుగు'),
        ),
      ],
    );
  }

  void _setLocale(String? value) {
    if (value == null) return;
    if (value == 'en') {
      _flutterLocalization.translate('en');
    } else if (value == 'de') {
      _flutterLocalization.translate('de');
    } else if (value == 'hi') {
      _flutterLocalization.translate('hi');
    } else if (value == 'mr') {
      _flutterLocalization.translate('mr');
    } else if (value == 'gu') {
      _flutterLocalization.translate('gu');
    } else if (value == 'te') {
      _flutterLocalization.translate('te');
    } else {
      return;
    }

    setState(() {
      _currentLocale = value;
    });
  }
}
