import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_1/mongodb/mongodb.dart';
import 'package:test_1/mongodb/user_model.dart';
import 'package:test_1/screens/UI/models/tabIcon_data.dart';
import 'package:test_1/screens/UI/my_diary/prev_and_prec.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fitness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  // const FitnessAppHomeScreen({super.key, this.mobile});
  const FitnessAppHomeScreen({super.key, required this.mobile});

  final String mobile;

  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  bool isAppend = false;
  String addressData = '';
  bool checkTimer = true;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    _getLocationData();

    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    tabBody = MyDiaryScreen(
      animationController: animationController,
      userAddress: addressData,
    );
    super.initState();
    int i = 0;
    print('User - ${widget.mobile}');
    // Timer.periodic(Duration(seconds: 11), (timer) async {
    //   //code to run on every 5 seconds
    //   print('object - ${i++}');
    //   if (isAppend == true) {
    //     await _updateData(
    //       widget.mobile,
    //       latData.toString(),
    //       longData.toString(),
    //     );
    //   }
    // });

    //Get Address Timer
    Timer.periodic(Duration(seconds: 6), (timer) {
      if (addressData != '') {
        setState(() {
          checkTimer = false;
          log('Home Address - $addressData');
          tabBody = MyDiaryScreen(
            animationController: animationController,
            userAddress: addressData,
          );
          bottomBar();
        });
        timer.cancel();
      }
    });
  }

  //Location logic
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";
  String latData = '111';
  String longData = '222';

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print('Service Disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  //Geocoding to get address
  _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.subLocality}, ${place.locality}, ${place.country}";
        addressData = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
    // log('User address - $addressData');
  }

  _getLocationData() async {
    // print('Location Received');
    _currentLocation = await _getCurrentLocation();
    await _getAddressFromCoordinates();
    // print('${_currentLocation}');
    latData = _currentLocation!.latitude.toString();
    longData = _currentLocation!.longitude.toString();
    // isLoc = true;
    // await _checkLocOn(isLoc);
    isAppend = true;
  }

  // @override
  // void dispose() {
  //   animationController?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // print('INNN HOMEEE');
    // final ap = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  checkTimer == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                          ),
                        )
                      : Center(child: Text(addressData)),
                  // tabBody,
                  // bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  // tabBody = (addressData == '')
                  //     ? const Center(
                  //         child: CircularProgressIndicator(
                  //           color: Colors.purple,
                  //         ),
                  //       )
                  //     : MyDiaryScreen(
                  //         animationController: animationController,
                  //         userAddress: addressData,
                  //       );
                  MyDiaryScreen(
                    animationController: animationController,
                    userAddress: addressData,
                  );
                });
              });
            } else if (index == 1 || index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      // TrainingScreen(animationController: animationController);
                      PrevAndPrec(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }

  //MongoDB functions
  Future<void> _updateData(String mobileNo, String lat, String long) async {
    final updateData = Model(mobile: mobileNo, latitude: lat, longitude: long);
    await MongoDatabase.update(updateData);
  }
}
