import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:test_1/mongodb/constant.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print("Status = " + status.toString());

    //Opening collection
    var collection = db.collection(COLLECTION_NAME);

    //Check existing user
    var exist = await collection.find({'phone': '1234567890'}).toList();

    if (exist.isEmpty) {
      //USER DOESN'T EXIST, ADD NEW RECORD
      await collection.insertOne({
        "phone": "9689061841",
        "address": "Pimple Gurav, Pune",
        "latitude": "19.530823",
        "longitude": "72.847466",
        "date_time": "3/1/2024, 11:01:00",
        "exists": "true"
      });

      var listAll = await collection.find().toList();
      print("NEW RECORD = $listAll");
    } else {
      //USER EXIST'S, UPDATE CURRENT RECORD
      print("USER EXITS");
      print("BEFORE UPDATE = ${exist[0]}");

      final filter = where.eq('phone', '1234567890');
      final update = modify.set('latitude', '111111111').set('longitude', '1111');
      await collection.update(filter, update, multiUpdate: true);

      var userUpdated = await collection.find({'phone': '1234567890'}).toList();
      print("AFTER UPDATE = ${userUpdated[0]}");
    }

    // Fetch and display all records
    print(await collection.find().toList());
  }
}
