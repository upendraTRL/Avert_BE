import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoading = true;

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
      // userAddress: addressData,
    );

    super.initState();

    int i = 0;
    print('User - ${widget.mobile}');
    Timer.periodic(Duration(seconds: 11), (timer) async {
      //code to run on every 5 seconds
      print('object - ${i++}');
      if (isAppend == true) {
        await _updateData(
          widget.mobile,
          latData.toString(),
          longData.toString(),
        );
      }
    });

    //Get Address Timer
    Timer.periodic(Duration(seconds: 6), (timer) {
      if (addressData != '') {
        _storeUserAddress();
        isLoading = false;
        setState(() {
          log('Home Address - $addressData');
        });
        timer.cancel();
      }
    });
  }

  //User address shared pref
  Future<void> _storeUserAddress() async {
    final prefs = await SharedPreferences.getInstance();

    log('Value setting - $addressData');

    await prefs.setString('userAddress', addressData);

    await MongoDatabase.updateDisplayAddress(userAddress, addressData);

    // if (prefs.getString('currentUserAddress') == null ||
    //     prefs.getString('currentUserAddress') != addressData) {
    //   await prefs.setString('currentUserAddress', addressData);
    // }
  }

  //Location logic
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";
  String latData = '111';
  String longData = '222';
  var userAddress = 'India';

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
      final prefs = await SharedPreferences.getInstance();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );

      var userLat = _currentLocation!.latitude;
      var userLong = _currentLocation!.longitude;

      log('User Lat - $userLat');

      if (userLat >= 16.4151 && userLat <= 16.7050) {
        userAddress = 'Kolhapur';
        await prefs.setString('isLocChanged', 'true');
      }
      if (userLat >= 18.9220 && userLat <= 19.0596) {
        userAddress = 'Mumbai';
        await prefs.setString('isLocChanged', 'true');
      }
      if (userLat >= 18.5074 && userLat <= 18.5679) {
        userAddress = 'Pune';
        await prefs.setString('isLocChanged', 'true');
      }
      if (userLat >= 18.4088 &&
          userLat <= 18.7062 &&
          userLong >= 76.5604 &&
          userLong <= 76.9384) {
        userAddress = 'Latur';
        await prefs.setString('isLocChanged', 'true');
      }

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.subLocality}, ${place.locality}";
        // "${place.subLocality}, ${place.locality}, ${place.country}";
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

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('INNN HOMEEE');
    // final ap = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : FutureBuilder<bool>(
                future: getData(context),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return Stack(
                      children: <Widget>[
                        // checkTimer == true
                        //     ? const Center(
                        //         child: CircularProgressIndicator(
                        //           color: Colors.purple,
                        //         ),
                        //       )
                        //     : Center(child: Text(addressData)),
                        tabBody,
                        bottomBar(),
                      ],
                    );
                  }
                },
              ),
      ),
    );
  }

  Future<bool> getData(BuildContext context) async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();

    // MongoDatabase.getQueryData('Mumbai');

    //First time app run
    if (prefs.getString('pastLangCode') == null ||
        prefs.getString('currentLocation') == null) {
      context.read<MongoDatabase>().firstTimeLoc(userAddress);
    }

    //Lang Change
    if (prefs.getString('isChanged') == 'true') {
      context.read<MongoDatabase>().translatedPrevPrec();
    }

    //Location Updated with Stored Lang
    if (prefs.getString('currentLocation') != userAddress) {
      context.read<MongoDatabase>().getQueryData(userAddress);
      // context.read<MongoDatabase>().translatedPrevPrec();
    } else {
      //Daily App Open
      context.read<MongoDatabase>().storedPrevPrec();
    }

    // MongoDatabase().getQueryData(userAddress);
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
                  tabBody = MyDiaryScreen(
                    animationController: animationController,
                    // userAddress: addressData,
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
    final updateData = Model(
      mobile: mobileNo,
      latitude: lat,
      longitude: long,
      address: addressData,
    );
    await MongoDatabase.update(updateData);
  }
}
