import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/widgets/lang_dropdown.dart';
import 'package:translator/translator.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:test_1/screens/UI/ui_view/body_view.dart';
import 'package:test_1/screens/UI/ui_view/prev_prec_info.dart';
import 'package:test_1/screens/UI/ui_view/title_view.dart';
import 'package:test_1/screens/UI/fitness_app_theme.dart';

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
  String preventions = 'Preventions';
  String precautions = 'Precautions';
  // late String _pastLocale;
  bool isLoading = true;

  // late FlutterLocalization _flutterLocalization;
  // late String _currentLocale;
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

    // _storeLangCode('en', 'en');

    addAllListData();

    // _flutterLocalization = FlutterLocalization.instance;
    // _currentLocale = _flutterLocalization.currentLocale!.languageCode;

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

  // Future<void> _storeLangCode(
  //     String pastLangCode, String currentLangCode) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   await prefs.setString('pastLangCode', pastLangCode);
  //   await prefs.setString('currentLangCode', currentLangCode);

  //   log('Default Lang Code Stored');
  // }

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
        // titleTxt: 'prevBodyy',
        titleTxt: 'preventions',
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
        titleTxt: 'precautions',
        // titleTxt: 'precBody',
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
  // String dropdownValue = 'English';
  // final String _currentAddress = "";
  // String latData = '111';
  // String longData = '222';
  // String addressData = 'India';

  // List<String> languages = [
  //   'English',
  //   'Hindi',
  //   'Tamil',
  //   'Kannada',
  //   'Gujrati',
  //   'Urdu',
  //   'Japanese	',
  //   'German'
  // ];
  // List<String> languagescode = [
  //   'en',
  //   'hi',
  //   'ta',
  //   'kn',
  //   'gu',
  //   'ur',
  //   'ja',
  //   'de',
  // ];
  // final translator = GoogleTranslator();
  // String defaultFrom = 'en';
  // String from = 'en';
  // String to = 'hi';
  // String selectedvalue2 = 'Hindi';
  // bool isloading = false;
  // translate() async {
  //   try {
  //     await translator
  //         .translate(_currentAddress, from: from, to: to)
  //         .then((value) {
  //       print("Frommmmmmmmmmm 1 - " + from);
  //       print("Tooooooooooooo 1 - " + to);
  //       addressData = value.text;
  //       isloading = false;
  //       setState(() {});
  //       // print("Afterrrrrrrrrrrr - " + addressData);
  //       // print("Frommmmmmmmmmm 1 - " + from);
  //       // print("Tooooooooooooo 2 - " + to);
  //     });
  //   } on SocketException catch (_) {
  //     isloading = true;
  //     SnackBar mysnackbar = const SnackBar(
  //       content: Text('Internet not Connected'),
  //       backgroundColor: Colors.red,
  //       duration: Duration(seconds: 5),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
  //     setState(() {});
  //   }
  // }

//Returning stored value
  // Future<String> _getIntFromSharedPref() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   preventions = prefs.getString('preventions')!;
  //   precautions = prefs.getString('precautions')!;

  //   log('Getting precautions data - $precautions');

  //   // if (startupNumber == null) return 0;

  //   isLoading = false;

  //   log('Getting Prev Info - $preventions');

  //   // while (precautions != 'Precautions') {}

  //   setState(() {
  //     addAllListData();
  //   });

  //   return preventions;
  // }

  // Future<void> _translatePrevPrec() async {
  //   log('Getting precautions data - $precautions');

  //   setState(() {
  //     addAllListData();
  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  isLoading == true
        //     ? const Center(
        //         child: CircularProgressIndicator(
        //           color: Colors.purple,
        //         ),
        //       )
        //     :
        Container(
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  LangDropdown(),
                                  // DropdownButton(
                                  //   value: _currentLocale,
                                  //   icon: const Padding(
                                  //     padding:
                                  //         EdgeInsets.symmetric(horizontal: 10),
                                  //     child: Icon(Icons.translate),
                                  //   ),
                                  //   onChanged: (value) async {
                                  //     _pastLocale = _currentLocale;
                                  //     _setLocale(value);
                                  //     log('Past = $_pastLocale');
                                  //     log('Current = $_currentLocale');
                                  //     final translation =
                                  //         await precautions.translate(
                                  //       from: _pastLocale,
                                  //       to: _currentLocale,
                                  //     );
                                  //     setState(() {
                                  //       precautions = translation.text;
                                  //       _translatePrevPrec();
                                  //     });
                                  //   },
                                  //   items: const [
                                  //     DropdownMenuItem(
                                  //       value: 'en',
                                  //       child: Text('English'),
                                  //     ),
                                  //     DropdownMenuItem(
                                  //       value: 'hi',
                                  //       child: Text('हिंदी'),
                                  //     ),
                                  //     DropdownMenuItem(
                                  //       value: 'mr',
                                  //       child: Text('मराठी'),
                                  //     ),
                                  //     DropdownMenuItem(
                                  //       value: 'gj',
                                  //       child: Text('ગુજરાતી'),
                                  //     ),
                                  //     DropdownMenuItem(
                                  //       value: 'tu',
                                  //       child: Text('తెలుగు'),
                                  //     ),
                                  //   ],
                                  // )
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
