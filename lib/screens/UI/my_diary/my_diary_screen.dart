import 'dart:io';

import 'package:test_1/screens/UI/ui_view/area_list_view.dart';
import 'package:test_1/screens/UI/ui_view/mediterranean_diet_view.dart';
import 'package:test_1/screens/UI/ui_view/title_view.dart';
import 'package:test_1/screens/UI/fitness_app_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_1/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
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

    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Area',
    //     subTxt: 'Details',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //             Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //   ),
    // );
    listViews.add(
      MediterranesnDietView(
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

    // listViews.add(
    //   MealsListView(
    //     mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //         CurvedAnimation(
    //             parent: widget.animationController!,
    //             curve: Interval((1 / count) * 3, 1.0,
    //                 curve: Curves.fastOutSlowIn))),
    //     mainScreenAnimationController: widget.animationController,
    //   ),
    // );

    listViews.add(
      TitleView(
        titleTxt: 'Features',
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

    // listViews.add(
    //   BodyMeasurementView(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //             Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //   ),
    // );
    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Water',
    //     subTxt: 'Aqua SmartBottle',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //             Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //   ),
    // );

    // listViews.add(
    //   WaterView(
    //     mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //         CurvedAnimation(
    //             parent: widget.animationController!,
    //             curve: Interval((1 / count) * 7, 1.0,
    //                 curve: Curves.fastOutSlowIn))),
    //     mainScreenAnimationController: widget.animationController!,
    //   ),
    // );
    // listViews.add(
    //   GlassView(
    //       animation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //           CurvedAnimation(
    //               parent: widget.animationController!,
    //               curve: Interval((1 / count) * 8, 1.0,
    //                   curve: Curves.fastOutSlowIn))),
    //       animationController: widget.animationController!),
    // );
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
                                  DropdownButton<String>(
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
                                    },
                                    items: const [
                                      DropdownMenuItem<String>(
                                        value: 'English',
                                        child: Text('English'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Hindi',
                                        child: Text('हिंदी'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Marathi',
                                        child: Text('मराठी'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Gujarati',
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
