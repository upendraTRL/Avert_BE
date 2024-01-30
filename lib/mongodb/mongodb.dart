import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:test_1/mongodb/constant.dart';
import 'package:test_1/mongodb/user_model.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    print('Inspect - ');
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  //USE FOR QUERY
  static Future<List<Map<String, dynamic>>> getQueryData() async {
    // var whereCondition = "where.gt('latitude',${150}).lt('longitude',${170})";
    final data = await userCollection
        .find(where.gt('latitude', '100').lt('latitude', '200'))
        .toList();
    return data;
  }

  static Future<void> update(Model data) async {
    //Mongo CRUD - https://pub.dev/packages/mongo_dart

    var response = await userCollection.findOne({"mobile": data.mobile});
    response["mobile"] = data.mobile;
    response["lat"] = data.lat;
    response["long"] = data.long;
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
