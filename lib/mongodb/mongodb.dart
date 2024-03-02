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
  String caution;
  String currentUserAddress;
  MongoDatabase({
    this.prevInfo = 'Loading...',
    this.precInfo = 'Loading...',
    this.caution = 'Loading...',
    this.currentUserAddress = 'Loading...',
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

  //App reload info display
  void storedPrevPrec() async {
    log('Prev-Prec Info Available');

    final prefs = await SharedPreferences.getInstance();
    prevInfo = prefs.getString('displayPreventions')!;
    precInfo = prefs.getString('displayPrecautions')!;
    caution = prefs.getString('displayCaution')!;
    currentUserAddress = prefs.getString('displayCurrentUserAddress')!;

    log('STORED CHECK - $caution');

    notifyListeners();
  }

  void displayDefaultInfo() async {
    final prefs = await SharedPreferences.getInstance();

    prevInfo = prefs.getString('defaultPreventions')!;
    precInfo = prefs.getString('defaultPrecautions')!;
    caution = prefs.getString('defaultCaution')!;
    currentUserAddress = prefs.getString('defaultCurrentUserAddress')!;

    await prefs.setString('displayPreventions', prevInfo);
    await prefs.setString('displayPrecautions', precInfo);
    await prefs.setString('displayCaution', caution);
    await prefs.setString('displayCurrentUserAddress', currentUserAddress);

    log('ENGLISH INFO - $caution');

    notifyListeners();
  }

  // Future<String> translateEngine(String toText, String currentLocale) async {
  //   final translated = await caution.translate(
  //     from: 'en',
  //     to: currentLocale,
  //   );

  //   String returnText = translated.text;

  //   return returnText;
  // }

  //Dropdown language change
  void translatedPrevPrec() async {
    log('Translated');
    final prefs = await SharedPreferences.getInstance();

    String prevInfoDefault = prefs.getString('defaultPreventions')!;
    String precInfoDefault = prefs.getString('defaultPrecautions')!;
    String cautionDefault = prefs.getString('defaultCaution')!;
    String currentUserAddressDefault =
        prefs.getString('defaultCurrentUserAddress')!;

    String currentLocale = prefs.getString('currentLangCode')!;

    if (currentLocale != 'en') {
      log('Not English - $currentLocale');
      // log('FROM ENGLISH - $cautionDefault');

      final translationCaution = await cautionDefault.translate(
        from: 'en',
        to: currentLocale,
      );

      final translationUserAddress = await currentUserAddressDefault.translate(
        from: 'en',
        to: currentLocale,
      );

      final translationPrev = await prevInfoDefault.translate(
        from: 'en',
        to: currentLocale,
      );

      final translationPrec = await precInfoDefault.translate(
        from: 'en',
        to: currentLocale,
      );

      // caution = futureCaution.toString();

      caution = translationCaution.text;
      currentUserAddress = translationUserAddress.text;
      prevInfo = translationPrev.text;
      precInfo = translationPrec.text;

      log('TRANSLATED - $precInfo');

      await prefs.setString('displayPreventions', prevInfo);
      await prefs.setString('displayPrecautions', precInfo);
      await prefs.setString('displayCaution', caution);
      await prefs.setString('displayCurrentUserAddress', currentUserAddress);

      await prefs.setString('isChanged', 'false');

      notifyListeners();
    } else {
      displayDefaultInfo();
    }
  }

  //Location changed - Eng Lang
  Future<void> getQueryData(String userAddress) async {
    log('Updated Location.');

    final data = await disasterInfoCollection.findOne({"address": userAddress});
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('currentLocation', userAddress);

    prevInfo = data["preventions"];
    precInfo = data["precautions"];
    caution = data["disaster_type"];
    currentUserAddress = data["displayAddress"];
    // currentUserAddress = prefs.getString('currentUserAddress')!;

    await prefs.setString('defaultPreventions', prevInfo);
    await prefs.setString('defaultPrecautions', precInfo);
    await prefs.setString('defaultCaution', caution);
    await prefs.setString('defaultCurrentUserAddress', currentUserAddress);

    await prefs.setString('displayPreventions', prevInfo);
    await prefs.setString('displayPrecautions', precInfo);
    await prefs.setString('displayCaution', caution);
    await prefs.setString('displayCurrentUserAddress', currentUserAddress);

    translatedPrevPrec();

    return data;
  }

  //First time app run
  Future<void> firstTimeLoc(String userAddress) async {
    log('First Location.');
    final data = await disasterInfoCollection.findOne({"address": userAddress});
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('currentLocation', userAddress);
    // currentUserAddress = prefs.getString('currentUserAddress')!;

    // prevInfo = data["preventions"];
    // precInfo = data["precautions"];

    await prefs.setString('pastLangCode', 'en');
    await prefs.setString('currentLangCode', 'en');

    prevInfo = data["preventions"];
    precInfo = data["precautions"];
    caution = data["disaster_type"];
    currentUserAddress = data["displayAddress"];

    await prefs.setString('defaultPreventions', prevInfo);
    await prefs.setString('defaultPrecautions', precInfo);
    await prefs.setString('defaultCaution', caution);
    await prefs.setString('defaultCurrentUserAddress', currentUserAddress);

    await prefs.setString('displayPreventions', prevInfo);
    await prefs.setString('displayPrecautions', precInfo);
    await prefs.setString('displayCaution', caution);
    await prefs.setString('displayCurrentUserAddress', currentUserAddress);

    notifyListeners();

    return data;
  }

  static Future<void> updateDisplayAddress(String key, String address) async {
    log('Update User Loc');

    //Dynamic Display Loc Update
    log('---------------- $key');
    var replaceAddress = await disasterInfoCollection.findOne({"address": key});
    replaceAddress["displayAddress"] = address;

    await disasterInfoCollection.replaceOne({"address": key}, replaceAddress);
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
