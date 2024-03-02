// import 'dart:js';

// import 'package:provider/provider.dart';
// import 'package:test_1/provider/auth_provider.dart';

class UserModel {
  String name;
  String email;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;
  String lat;
  String long;

  UserModel({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.phoneNumber,
    required this.profilePic,
    required this.uid,
    required this.lat,
    required this.long,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      profilePic: map['profilePic'] ?? '',
      lat: map['lat'] ?? '',
      long: map['long'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "lat": lat,
      "long": long,
    };
  }
}
