import 'package:mongo_dart/mongo_dart.dart';

import 'dart:convert';

Model mongoDbModelFromJson(String str) => Model.fromJson(json.decode(str));

String mongoDbModelToJson(Model data) => json.encode(data.toJson());

class Model {
  // ObjectId id;
  String mobile;
  // String fname;
  String latitude;
  String longitude;
  String address;

  Model({
    // required this.id,
    required this.mobile,
    // required this.fname,
    required this.latitude,
    required this.longitude,
    this.address = 'India',
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        mobile: json['mobile'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "mobile": mobile,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      };
}
