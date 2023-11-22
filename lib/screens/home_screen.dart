import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'package:test_1/provider/auth_provider.dart';
import 'package:test_1/screens/welcome_screen.dart';
import 'package:test_1/widgets/custome_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//Location logic
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";
  String latData = '111';
  String longData = '222';
  String addressData = 'India';
  // String translatedAdd = 'null';

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
  }

  //Translation logic
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
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String username = ap.userModel.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Avert"),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
          DropdownButton(
            value: selectedvalue2,
            focusColor: Colors.transparent,
            items: languages.map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Text(lang),
                onTap: () {
                  if (defaultFrom != 'en') {
                    from = to;
                  }
                  from = to;
                  if (lang == languages[0]) {
                    to = languagescode[0];
                  } else if (lang == languages[1]) {
                    to = languagescode[1];
                  } else if (lang == languages[2]) {
                    to = languagescode[2];
                  } else if (lang == languages[3]) {
                    to = languagescode[3];
                  } else if (lang == languages[4]) {
                    to = languagescode[4];
                  } else if (lang == languages[5]) {
                    to = languagescode[5];
                  } else if (lang == languages[6]) {
                    to = languagescode[6];
                  } else if (lang == languages[7]) {
                    to = languagescode[7];
                  } else if (lang == languages[8]) {
                    to = languagescode[8];
                  }
                  setState(() {
                    print(lang);
                    print(from);
                  });
                },
              );
            }).toList(),
            onChanged: (value) {
              selectedvalue2 = value!;
              translate();
            },
            // onTap: translate,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text(
                'Chinmay B',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Preventions'),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => MyPrevention()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Precautions'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.text_format),
              title: const Text('Survey Form'),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => MySurveyPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.gps_fixed),
              title: const Text('Map'),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => MyRescuePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Languages'),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => MyLangPage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            // padding: EdgeInsets.all(16),
            // color: Colors.grey[200],
            child: Card(
              margin: EdgeInsets.only(bottom: 10, top: 20),
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(addressData, style: TextStyle(fontSize: 32)),
                    SizedBox(height: 15),
                    Text(
                      'Temparature: 35 C \n\nCalamity: Tsunami \n\nPrecautions: Safe Location - Kothrud',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '\nLatitude: $latData \n\nLongitude: $longData',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(ap.userModel.phoneNumber),
          Text(ap.userModel.email),
          const SizedBox(height: 20),
          // Text("Address - $addressData"),
          // Text(addressData),
          const SizedBox(height: 20),
          // Text("Lat = $latData"),
          const SizedBox(height: 20),
          // Text("Long = $longData"),
          const SizedBox(height: 50),
          SizedBox(
            width: 200,
            height: 50,
            child: CustomButton(
              onPressed: () async {
                setState(() async {
                  _currentLocation = await _getCurrentLocation();
                  await _getAddressFromCoordinates();
                  // print('${_currentLocation}');
                  latData = _currentLocation!.latitude.toString();
                  longData = _currentLocation!.longitude.toString();
                });
              },
              text: "S.O.S",
            ),
          )
        ],
      )),
    );
  }
}
