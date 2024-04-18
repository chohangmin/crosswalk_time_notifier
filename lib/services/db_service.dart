import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:csv/csv.dart';

class DbService {
  List<List<dynamic>> parseCsv(String csvString) {
    return const CsvToListConverter().convert(csvString);
  }

  void makeDb() async {
    String csvString = await rootBundle.loadString('data.csv');

    List<List<dynamic>> csvData = parseCsv(csvString);

    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    await deleteDatabase(path);

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE crossInfo (id INTEGER PRIMARY KEY, name TEXT, lat REAL, lot REAL)');
    });

    Batch batch = database.batch();
    for (int i = 1; i < csvData.length; i++) {
      var row = csvData[i];
      String id = row[0].toString();
      String name = row[1].toString();
      double lat = double.parse(row[2].toString());
      double lot = double.parse(row[3].toString());

      batch.insert('crossInfo', {
        'id': id,
        'name': name,
        'lat': lat,
        'lot': lot,
      });
    }
    await batch.commit();

    await database.close();
  }

  Future<List<Map<String, dynamic>>> getAllow() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    Database database = await openDatabase(path);

    List<Map<String, dynamic>> result = await database.query('crossInfo');

    return result;
  }
}
