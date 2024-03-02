import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_1/localization/locales.dart';
import 'package:test_1/mongodb/mongodb.dart';
import 'package:test_1/provider/auth_provider.dart';
import 'package:test_1/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MongoDatabase.connect();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MongoDatabase()),
      ],
      child: MaterialApp(
        // locale: Locale('fr'),
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
        // home: MyDiaryScreen(mobile: '+919689061841'),
        // home: MyDiaryScreen(),
        title: "Authentication",
        // title: AppLocalizations.of(context)!.helloWorld,
      ),
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: 'en');
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}
