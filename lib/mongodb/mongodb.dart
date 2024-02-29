import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/mongodb/constant.dart';
import 'package:test_1/mongodb/user_model.dart';
import 'package:translator/translator.dart';

class MongoDatabase extends ChangeNotifier {
  static var db, userCollection, disasterInfoCollection;

  String prevInfo;
  String precInfo;
  MongoDatabase({
    this.prevInfo = 'Loading...',
    this.precInfo = 'Loading...',
  });

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

  void storedPrevPrec() async {
    log('Prev-Prec Info Available');

    final prefs = await SharedPreferences.getInstance();
    prevInfo = prefs.getString('preventions')!;
    precInfo = prefs.getString('precautions')!;
    notifyListeners();
  }

  //Dropdown language change
  void translatedPrevPrec() async {
    log('Translated');
    final prefs = await SharedPreferences.getInstance();

    prevInfo = prefs.getString('preventions')!;
    precInfo = prefs.getString('precautions')!;

    String pastLocale = prefs.getString('pastLangCode')!;
    String currentLocale = prefs.getString('currentLangCode')!;

    final translationPrev = await prevInfo.translate(
      from: pastLocale,
      to: currentLocale,
    );

    final translationPrec = await precInfo.translate(
      from: pastLocale,
      to: currentLocale,
    );

    prevInfo = translationPrev.text;
    precInfo = translationPrec.text;

    await prefs.setString('preventions', prevInfo);
    await prefs.setString('precautions', precInfo);

    await prefs.setString('isChanged', 'false');

    notifyListeners();
  }

  //USE FOR QUERY
  // static Future<List<Map<String, dynamic>>> getQueryData(
  Future<void> getQueryData(String userAddress) async {
    //Location changed - Eng Lang
    final data = await disasterInfoCollection.findOne({"address": userAddress});
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('currentLocation', userAddress);

    // prevInfo = data["preventions"];
    // precInfo = data["precautions"];

    // if (prefs.getString('pastLangCode') == null) {
    //   await prefs.setString('pastLangCode', 'en');
    //   await prefs.setString('currentLangCode', 'en');
    // }

    log('Updated Location.');
    prevInfo = data["preventions"];
    precInfo = data["precautions"];


    await prefs.setString('preventions', prevInfo);
    await prefs.setString('precautions', precInfo);
    
    translatedPrevPrec();

    notifyListeners();

    return data;
  }

  //First time app run
  Future<void> firstTimeLoc(String userAddress) async {
    log('First Location.');
    final data = await disasterInfoCollection.findOne({"address": userAddress});
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('currentLocation', userAddress);

    // prevInfo = data["preventions"];
    // precInfo = data["precautions"];

    await prefs.setString('pastLangCode', 'en');
    await prefs.setString('currentLangCode', 'en');

    prevInfo = data["preventions"];
    precInfo = data["precautions"];

    await prefs.setString('preventions', prevInfo);
    await prefs.setString('precautions', precInfo);

    notifyListeners();

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
