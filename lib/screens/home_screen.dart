import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:test_1/provider/auth_provider.dart';
import 'package:test_1/screens/welcome_screen.dart';
import 'package:test_1/widgets/custome_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    //Location logic
    Position? _currentLocation;
    late bool servicePermission = false;
    late LocationPermission permission;

    String _currentAddress = "";

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("FlutterPhone Auth"),
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
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple,
            backgroundImage: NetworkImage(ap.userModel.profilePic),
            radius: 50,
          ),
          const SizedBox(height: 20),
          Text(ap.userModel.name),
          Text(ap.userModel.phoneNumber),
          Text(ap.userModel.email),
          const SizedBox(height: 20),
          Text("Address - "),
          const SizedBox(height: 20),
          Text("Lat = "),
          const SizedBox(height: 20),
          Text("Long = "),
          const SizedBox(height: 50),
          SizedBox(
            width: 200,
            height: 50,
            child: CustomButton(
              onPressed: () async {
                _currentLocation = await _getCurrentLocation();
                print('${_currentLocation}');
              },
              text: "Get Location",
            ),
          )
        ],
      )),
    );
  }
}
