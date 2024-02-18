import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:test_1/mongodb/mongodb.dart';
import 'package:test_1/mongodb/user_model.dart';
import 'package:test_1/provider/auth_provider.dart';
import 'package:test_1/screens/UI/fitness_app_home_screen.dart';
import 'package:test_1/screens/user_Info_screen.dart';
import 'package:test_1/utils/utils.dart';
import 'package:test_1/widgets/custome_widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {super.key, required this.verificationId, required this.mobile});

  final String verificationId;
  final String mobile;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  //Location logic
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";
  String latData = '111';
  String longData = '222';
  String addressData = 'India';
  String isLoc = 'false';
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

  _getLocationData() async {
    // print('Location Received');
    _currentLocation = await _getCurrentLocation();
    await _getAddressFromCoordinates();
    // print('${_currentLocation}');
    latData = _currentLocation!.latitude.toString();
    longData = _currentLocation!.longitude.toString();
    isLoc = 'true';
    // await _checkLocOn(isLoc);

    if (isLoc == 'true') {
      await _updateData(
          widget.mobile, latData.toString(), longData.toString()); //WORKING
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple.shade50,
                        ),
                        child: Image.asset(
                          "assets/image2.png",
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Verification",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter the OTP send to your phone number",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Pinput(
                        length: 6,
                        showCursor: true,
                        defaultPinTheme: PinTheme(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.purple.shade200,
                            ),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onCompleted: (value) {
                          setState(() {
                            otpCode = value;
                          });
                        },
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: CustomButton(
                          text: "Verify",
                          onPressed: () {
                            if (otpCode != null) {
                              verifyOtp(
                                context,
                                otpCode!,
                              );
                            } else {
                              showSnackBar(context, "Enter 6-Digit code");
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Didn't receive any code?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Resend New Code",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.isLoading == true
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          )
        : ap.verifyOtp(
            context: context,
            verificationId: widget.verificationId,
            userOtp: userOtp,
            onSuccess: () {
              ap.checkExistingUser().then(
                (value) async {
                  if (value == true) {
                    // user exists in our app
                    await _getLocationData();
                    // print('MOBILE - ${widget.mobile}');
                    // await _updateData(widget.mobile, latData.toString(), longData.toString()); //WORKING
                    ap.getDataFromFirestore().then(
                          (value) => ap.saveUserDataToSP().then(
                                (value) => ap.setSignIn().then(
                                      (value) => Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            // builder: (context) => FitnessAppHomeScreen(mobile: widget.mobile ?? '+9100000000'),
                                            // builder: (context) => FitnessAppHomeScreen(mobile: '+919689061841'),
                                            builder: (context) =>
                                                FitnessAppHomeScreen(
                                              mobile: widget.mobile,
                                            ),
                                          ),
                                          (route) => false),
                                    ),
                              ),
                        );
                  } else {
                    //New user
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserInfoScreen(mobile: widget.mobile),
                          // builder: (context) => UserInfoScreen(mobile: '9689061841'),
                        ),
                        (route) => false);
                  }
                },
              );
            },
          );
  }

  //MongoDB functions

  Future<void> _updateData(String mobileNo, String lat, String long) async {
    final updateData = Model(mobile: mobileNo, latitude: lat, longitude: long);
    await MongoDatabase.update(updateData);
    // .whenComplete(() => Navigator.pop(context));
  }

  Future<void> _insertData(String mobileNo, String lat, String long) async {
    // var _id = M.ObjectId(); //THIS WILL USE FOR UNIQUE ID
    final data = Model(mobile: mobileNo, latitude: lat, longitude: long);
    // var result = await MongoDatabase.insert(data);
    await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID - $mobileNo")));
  }
}
