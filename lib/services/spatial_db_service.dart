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
          'CREATE VIRTUAL TABLE crossInfo USING rtree(id, minX, maxX, minY, maxY)');
    });

    Batch batch = database.batch();
    for (int i = 1; i < csvData.length; i++) {
      var row = csvData[i];
      String id = row[0].toString();
      String name = row[1].toString();
      double lat = double.parse(row[2].toString()) / 1e7;
      double lon = double.parse(row[3].toString()) / 1e7;

      batch.insert('crossInfo', {
        'id': id,
        'minX': lat,
        'maxX': lat,
        'minY': lon,
        'maxY': lon
      });
    }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getAllow() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    Database database = await openDatabase(path);

    List<Map<String, dynamic>> result = await database.query('crossInfo');

    return result;
  }

}
