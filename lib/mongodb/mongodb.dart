import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/mongodb/constant.dart';
import 'package:test_1/mongodb/user_model.dart';

class MongoDatabase {
  static var db, userCollection, disasterInfoCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    print('Inspect - ');
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
    disasterInfoCollection = db.collection(DISASTER_INFO_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  //USE FOR QUERY
  // static Future<List<Map<String, dynamic>>> getQueryData(
  static Future<void> getQueryData(String userAddress) async {
    final data = await disasterInfoCollection.findOne({"address": userAddress});

    // log(data["preventions"]);

    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('isChanged') == null) {
      await prefs.setString('isChanged', 'true');
    }

    if (prefs.getString('pastLangCode') == null) {
      await prefs.setString('pastLangCode', 'en');
      await prefs.setString('currentLangCode', 'en');
    }

    // await prefs.setString('preventions', 'This is preventions.');
    if (prefs.getString('preventions') == null) {
      await prefs.setString('preventions', data["preventions"]);
    }

    if (prefs.getString('precautions') == null) {
      await prefs.setString('precautions', data["precautions"]);
    }

    return data;
  }

  static Future<void> update(Model data) async {
    //Mongo CRUD - https://pub.dev/packages/mongo_dart

    var response = await userCollection.findOne({"mobile": data.mobile});
    response["mobile"] = data.mobile;
    response["latitude"] = data.latitude;
    response["longitude"] = data.longitude;
    await userCollection.replaceOne({"mobile": data.mobile}, response);

    inspect(response);
  }

  static Future<String> insert(Model data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return 'Data Inserted';
      } else {
        return 'Something went wrong while inserting!';
      }
    } catch (e) {
      print('Insert Exception - $e');
      return e.toString();
    }
  }
}
