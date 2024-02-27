import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_1/screens/UI/ui_view/prev_prec_info.dart';
import 'package:test_1/widgets/lang_dropdown.dart';
import 'package:translator/translator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:test_1/screens/UI/ui_view/area_list_view.dart';
import 'package:test_1/screens/UI/ui_view/mediterranean_diet_view.dart';
import 'package:test_1/screens/UI/ui_view/title_view.dart';
import 'package:test_1/screens/UI/fitness_app_theme.dart';

enum Language { english, french }

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({
    Key? key,
    this.animationController,
    // required this.userAddress,
  }) : super(key: key);

  final AnimationController? animationController;
  // final String userAddress;
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen>
    with TickerProviderStateMixin {
  final urlImages = [
    'https://img.freepik.com/free-photo/3d-rendering-cartoon-house_23-2150165654.jpg?w=826&t=st=1703674332~exp=1703674932~hmac=730768e8a483860660c6c3268b1209beba793a0a708350616a17c662800a9bf2',
    'https://img.freepik.com/free-vector/firefighter-extinguishing-flame-character-rescuer-dangerous-job-fire-protection-fire-prevention-technologies-fire-protection-services-concept-pinkish-coral-bluevector-isolated-illustration_335657-1504.jpg?w=1060&t=st=1703673947~exp=1703674547~hmac=ccdf69644a6d793a66283804bb8703ae4c1891faae72913ba20dfe0c03e8ff4a',
    'https://img.freepik.com/premium-vector/natural-cataclysm-disasters-flood-safeguard-rescue-boat-service-rescued-saved-people-from-flooded-house-vector-illustration-flood-natural-disaster-rescuers_229548-1928.jpg?w=1060',
    'https://media.istockphoto.com/id/1197437023/vector/flood-disaster-flooding-water-in-city-street-vector-design.jpg?s=1024x1024&w=is&k=20&c=bOLGD_cV0O_madmLXk111qM8AuhgTtCs2z-D3hW_E28='
  ];
  Animation<double>? topBarAnimation;

  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool getAddress = false;

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

    //Get User Address
    // Timer.periodic(Duration(seconds: 6), (timer) {
    //   if (widget.userAddress != '') {
    //     setState(() {
    //       addAllListData();
    //       log('Diary Address - ${widget.userAddress}');
    //     });
    //     timer.cancel();
    //   }
    // });
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      // MediterranesnDietView(
      PrevPrecInfo(
        // userAddress: widget.userAddress,
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
    listViews.add(
      TitleView(
        // titleTxt: context.formatString(LocaleData.updates, ['User']),
        titleTxt: 'Updates',
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
      CarouselSlider.builder(
        itemCount: urlImages.length,
        options: CarouselOptions(
          height: 250,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        itemBuilder: (context, index, realIndex) {
          int activeIndex = 0;
          final urlImage = urlImages[index];

          return buildImage(urlImage, index);
        },
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Features',
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
      AreaListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(
              (1 / count) * 5,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        mainScreenAnimationController: widget.animationController!,
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
  // String addressData = 'India';

  List<String> languages = [
    'English',
    'Hindi',
    'Marathi',
    'Gujrati',
    'Telugu',
    'German'
  ];
  List<String> languagescode = [
    'en',
    'hi',
    'mr',
    'gj',
    'tu',
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
        // addressData = value.text;
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
    // log('My Diary - ${widget.userAddress}');
    log('Diary Page Widget');

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
    } else if (value == 'mr') {
      _flutterLocalization.translate('mr');
    } else if (value == 'gj') {
      _flutterLocalization.translate('gj');
    } else if (value == 'tu') {
      _flutterLocalization.translate('tu');
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
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  LangDropdown(),
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
