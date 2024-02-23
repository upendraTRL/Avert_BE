import 'dart:async';
import 'dart:developer';

import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/localization/locales.dart';
import 'package:test_1/screens/UI/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class BodyView extends StatefulWidget {
  const BodyView({
    super.key,
    this.titleTxt = "",
    this.subTxt = "",
    this.animationController,
    this.animation,
  });

  final String titleTxt;
  final String subTxt;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView> {
  late String titleValue = '';
  late String dummyText = '';

  late String? currentLocale;
  late String? pastLocale;

  @override
  void initState() {
    super.initState();
    // getLangCodesFromSharedPref();
  }

  // Returning stored value

  Future<void> getLangCodesFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    pastLocale = prefs.getString('pastLangCode');
    currentLocale = prefs.getString('currentLangCode');

    log('GETTING LANG CODES - $pastLocale, $currentLocale');

    String testText = widget.titleTxt;
    // String testText = 'Hello';
    // log('B4 Trasnlation - $testText');

    final translation = await testText.translate(
      from: pastLocale!,
      to: currentLocale!,
    );

    titleValue = translation.text;
    log('After Trasnlation - $titleValue');

    if (titleValue != testText) {
      await prefs.setString('preventions', titleValue);
      // await prefs.setString('precautions', titleValue);
      setState(() {});
    }

    // if (pastLocale != null && currentLocale != null) {
    //   final translation = await testText.translate(
    //     from: 'en',
    //     to: 'hi',
    //     // from: pastLocale!,
    //     // to: currentLocale!,
    //   );

    //   testText = translation.text;
    //   log('After Trasnlation - $testText');

    //   // setState(() {
    //   //   titleValue = translation.text;
    //   // });
    // }
  }

  void changeContent() {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Body view page');
    getLangCodesFromSharedPref();
    // setState(() {});

    dummyText = context.formatString(LocaleData.updates, ['']);

    // if (widget.titleTxt != 'Updates') {
    //   dummyText = context.formatString(LocaleData.updates, ['']);
    //   getLangCodesFromSharedPref();
    // }

    // if (widget.titleTxt == 'Updates') {
    //   titleValue = context.formatString(LocaleData.updates, ['']);
    // } else if (widget.titleTxt == 'Features') {
    //   titleValue = context.formatString(LocaleData.features, ['']);
    // } else if (widget.titleTxt == 'prevBody') {
    //   titleValue = context.formatString(LocaleData.prevBody, ['']);
    // } else if (widget.titleTxt == 'precBody') {
    //   titleValue = context.formatString(LocaleData.precBody, ['']);
    // } else {
    //   titleValue = testText;
    //   // titleValue = widget.titleTxt;

    //   // log('Before Trasnlation - $titleValue');

    //   getLangCodesFromSharedPref();
    //   // getLangCodesFromSharedPref(titleValue);

    //   // log('After Trasnlation - $titleValue');
    //   // setState(() {});
    // }

    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleValue,
                        // widget.titleTxt,
                        // AppLocalizations.of(context)!.helloWorld,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: FitnessAppTheme.lightText,
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.subTxt,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                letterSpacing: 0.5,
                                color: FitnessAppTheme.nearlyDarkBlue,
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 26,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Color.fromARGB(0, 0, 0, 0),
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
