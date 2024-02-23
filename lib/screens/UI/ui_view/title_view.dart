import 'dart:developer';

import 'package:flutter_localization/flutter_localization.dart';
import 'package:test_1/localization/locales.dart';
import 'package:test_1/screens/UI/fitness_app_theme.dart';
import 'package:flutter/material.dart';

class TitleView extends StatefulWidget {
  const TitleView({
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
  State<TitleView> createState() => _TitleViewState();
}

class _TitleViewState extends State<TitleView> {
  late String titleValue = 'Updates';

  @override
  Widget build(BuildContext context) {
    log('Title View Page');

    if (widget.titleTxt == 'Updates') {
      titleValue = context.formatString(LocaleData.updates, ['']);
    } else if (widget.titleTxt == 'Features') {
      titleValue = context.formatString(LocaleData.features, ['']);
    } else if (widget.titleTxt == 'prevTitle') {
      titleValue = context.formatString(LocaleData.prevTitle, ['']);
    } else if (widget.titleTxt == 'precTitle') {
      titleValue = context.formatString(LocaleData.precTitle, ['']);
    }

    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Container(
              margin: EdgeInsets.only(top: 15),
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
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
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
