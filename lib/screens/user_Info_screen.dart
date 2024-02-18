import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:test_1/mongodb/model_firebase.dart';
import 'package:test_1/mongodb/mongodb.dart';
import 'package:test_1/mongodb/user_model.dart';
import 'package:test_1/provider/auth_provider.dart';
import 'package:test_1/screens/UI/fitness_app_home_screen.dart';
import 'package:test_1/utils/utils.dart';
import 'package:test_1/widgets/custome_widgets.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key, required this.mobile});

  final String mobile;

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    // Disposing the controllers when we dont need them
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  //Image selection
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

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
      _isLoading = true;

      await _insertData(widget.mobile, latData.toString(), longData.toString());

      _isLoading = false;

      // await _updateData(
      //     widget.mobile, latData.toString(), longData.toString()); //WORKING
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
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                child: Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => selectImage(),
                        child: image == null
                            ? const CircleAvatar(
                                backgroundColor: Colors.purple,
                                radius: 50,
                                child: Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(image!),
                                radius: 50,
                              ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // name field
                            textFeld(
                              hintText: "John Smith",
                              icon: Icons.account_circle,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: nameController,
                            ),

                            // email
                            textFeld(
                              hintText: "abc@example.com",
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              maxLines: 1,
                              controller: emailController,
                            ),

                            // mobile
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                cursorColor: Colors.purple,
                                readOnly: true,
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.purple,
                                    ),
                                    child: const Icon(
                                      Icons.phone,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  hintText: widget.mobile,
                                  alignLabelWithHint: true,
                                  border: InputBorder.none,
                                  fillColor: Colors.purple.shade50,
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Continue",
                          onPressed: () => storeData(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      profilePic: "",
      createdAt: "",
      // phoneNumber: widget.mobile,
      phoneNumber: "",
      uid: "",
      lat: "123", //Lat-Long value is getting stored
      long: "456",
    );
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () async {
          // await _insertData(widget.mobile, '111', '222');
          ap.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                )
              : await _getLocationData();

          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                // FitnessAppHomeScreen(mobile: widget.mobile),
                                FitnessAppHomeScreen(
                              mobile: widget.mobile,
                            ),
                            // FitnessAppHomeScreen(mobile: '+919689061841'),
                            // builder: (context) => MyDiaryScreen(
                            //     // mobile: widget.mobile
                            //     ),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your profile photo");
    }
  }

  //MongoDB Functions

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
