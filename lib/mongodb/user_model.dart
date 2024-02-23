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

  Model({
    // required this.id,
    required this.mobile,
    // required this.fname,
    required this.latitude,
    required this.longitude,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        mobile: json['mobile'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "mobile": mobile,
        "latitude": latitude,
        "longitude": longitude,
      };
}
