import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:test_1/mongodb/constant.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);

    //Opening collection
    var collection = db.collection(COLLECTION_NAME);

    //Check existing user
    var exist = await collection.find().toList();

    for (var avertRecords in exist) {
      if (avertRecords['exists'] == 'true') {
        //Update records, [Multiple fields]
        final filter = where.eq('phone', '1234567890');
        final update = modify.set('latitude', '11').set('longitude', '11');
        await collection.update(filter, update, multiUpdate: true);
      } else {
        //Insert Operation
        await collection.insertOne({
          "phone": "1234567890",
          "address": "Shivaji Nagar, Pune",
          "latitude": "18.530823",
          "longitude": "73.847466",
          "exists": "true"
        });
      }
    }

    //Fetch and display records
    print(await collection.find().toList());
  }
}
