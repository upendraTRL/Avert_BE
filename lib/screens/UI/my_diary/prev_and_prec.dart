import 'dart:io';

import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:test_1/controller/language_change_controller.dart';
import 'package:test_1/localization/locales.dart';
import 'package:test_1/screens/UI/ui_view/area_list_view.dart';
import 'package:test_1/screens/UI/ui_view/body_view.dart';
import 'package:test_1/screens/UI/ui_view/mediterranean_diet_view.dart';
import 'package:test_1/screens/UI/ui_view/prev_prec_info.dart';
import 'package:test_1/screens/UI/ui_view/title_view.dart';
import 'package:test_1/screens/UI/fitness_app_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_1/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Language { english, french }

class PrevAndPrec extends StatefulWidget {
  const PrevAndPrec({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _PrevAndPrecState createState() => _PrevAndPrecState();
}

class _PrevAndPrecState extends State<PrevAndPrec>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      PrevPrecInfo(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(
              (1 / count) * 1,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        animationController: widget.animationController!,
      ),
    );

    //Prevention Info
    listViews.add(
      TitleView(
        // titleTxt: context.formatString(LocaleData.updates, ['User']),
        titleTxt: 'prevTitle',
        // titleTxt: (updateTitle),
        // subTxt: 'Customize',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(
              (1 / count) * 2,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      BodyView(
        // titleTxt: context.formatString(LocaleData.updates, ['User']),
        titleTxt: 'prevBody',
        // titleTxt: (updateTitle),
        // subTxt: 'Customize',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(
              (1 / count) * 2,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        animationController: widget.animationController!,
      ),
    );

    SizedBox(height: 50);

    //Precaution Info
    listViews.add(
      TitleView(
        // titleTxt: context.formatString(LocaleData.features, ['User']),
        titleTxt: 'precTitle',
        // subTxt: 'Today',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(
              (1 / count) * 4,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      BodyView(
        // titleTxt: context.formatString(LocaleData.features, ['User']),
        titleTxt: 'precBody',
        // subTxt: 'Today',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(
              (1 / count) * 4,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        animationController: widget.animationController!,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  //Translation logic
  String dropdownValue = 'English';
  final String _currentAddress = "";
  String latData = '111';
  String longData = '222';
  String addressData = 'India';

  List<String> languages = [
    'English',
    'Hindi',
    'Tamil',
    'Kannada',
    'Gujrati',
    'Urdu',
    'Japanese	',
    'German'
  ];
  List<String> languagescode = [
    'en',
    'hi',
    'ta',
    'kn',
    'gu',
    'ur',
    'ja',
    'de',
  ];
  final translator = GoogleTranslator();
  String defaultFrom = 'en';
  String from = 'en';
  String to = 'hi';
  String selectedvalue2 = 'Hindi';
  bool isloading = false;
  translate() async {
    try {
      await translator
          .translate(_currentAddress, from: from, to: to)
          .then((value) {
        print("Frommmmmmmmmmm 1 - " + from);
        print("Tooooooooooooo 1 - " + to);
        addressData = value.text;
        isloading = false;
        setState(() {});
        // print("Afterrrrrrrrrrrr - " + addressData);
        // print("Frommmmmmmmmmm 1 - " + from);
        // print("Tooooooooooooo 2 - " + to);
      });
    } on SocketException catch (_) {
      isloading = true;
      SnackBar mysnackbar = const SnackBar(
        content: Text('Internet not Connected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
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
    } else {
      return;
    }

    setState(() {
      _currentLocale = value;
    });
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Avert',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_left,
                            //         color: FitnessAppTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 8),
                                  //   child: Icon(
                                  //     Icons.calendar_today,
                                  //     color: FitnessAppTheme.grey,
                                  //     size: 18,
                                  //   ),
                                  // ),
                                  DropdownButton(
                                    value: dropdownValue,
                                    icon: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(Icons.translate),
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                      _currentLocale = dropdownValue;
                                      _setLocale(dropdownValue);

                                      // langTrans();
                                      // addAllListData();
                                      print('Code - $dropdownValue');
                                    },
                                    items: const [
                                      DropdownMenuItem<String>(
                                        value: 'English',
                                        child: Text('English'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'hi',
                                        child: Text('हिंदी'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'de',
                                        child: Text('मराठी'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'en',
                                        child: Text('ગુજરાતી'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Kannada',
                                        child: Text('ಕನ್ನಡ'),
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   '15 May',
                                  //   textAlign: TextAlign.left,
                                  //   style: TextStyle(
                                  //     fontFamily: FitnessAppTheme.fontName,
                                  //     fontWeight: FontWeight.normal,
                                  //     fontSize: 18,
                                  //     letterSpacing: -0.2,
                                  //     color: FitnessAppTheme.darkerText,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 8,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                // child: Center(
                                //   child: Icon(
                                //     Icons.keyboard_arrow_right,
                                //     color: FitnessAppTheme.grey,
                                //   ),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

Widget buildImage(String urlImage, int index) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
      // padding: EdgeInsets.all(30),
      color: Colors.grey,
      child: Image.network(
        urlImage,
        fit: BoxFit.cover,
      ),
    );
