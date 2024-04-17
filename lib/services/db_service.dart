import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:csv/csv.dart';
import 'dart:io';

class DbService {
  List<List<dynamic>> parseCsv(String csvString) {
    return const CsvToListConverter().convert(csvString);
  }

  void makeDb() async {
    File csvFile = File('../../data.csv');
    String csvString = csvFile.readAsStringSync();

    List<List<dynamic>> csvData = parseCsv(csvString);

    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE crossInfo (id INTEGER PRIMARY KEY, name TEXT, lat REAL, lot REAL)');
    });

    Batch batch = database.batch();
    for (var row in csvData) {
      batch.insert('crossInfo', {
        'id': row[0],
        'name': row[1],
        'lat': row[2],
        'lot': row[3],
      });
    }
    await batch.commit();

    await database.close();
  }

  Future<List<Map<String, dynamic>>> getAllow() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    Database database = await openDatabase(path);

    // List<Map<String, dynamic>> result = await database.query(
    //   'crossInfo',
    //   where = 'name = ?',
    //   whereArgs: [condition],
    // );

    List<Map<String, dynamic>> result = await database.query('crossInfo');

    await database.close();

    return result;
  }
}
