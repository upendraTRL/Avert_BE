import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale('en', LocaleData.EN),
  MapLocale('de', LocaleData.DE),
  MapLocale('hi', LocaleData.HI),
];

mixin LocaleData {
  static const String title = 'title';
  static const String updates = 'updates';
  static const String features = 'features';
  static const String body = 'body';

  static const Map<String, dynamic> EN = {
    title: 'Localization',
    updates: 'Updates',
    features: 'Features',
    body: 'Welcome %a', //%a is used to dynamically add value, for eg: USER NAME
  };

  static const Map<String, dynamic> DE = {
    title: 'Deutsch',
    updates: 'Aktualisierung',
    features: 'Merkmale',
    body: 'Guten Morgen %a',
  };

  static const Map<String, dynamic> HI = {
    title: 'हिंदी',
    updates: 'जानकारी',
    features: 'विशेषताएँ',
    body: 'Hindi %a',
  };
}
