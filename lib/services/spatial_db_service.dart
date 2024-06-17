import 'dart:ffi';
import 'dart:io';

import 'package:crosswalk_time_notifier/models/cross_map_model.dart';
import 'package:crosswalk_time_notifier/services/locator_service.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:csv/csv.dart';
import 'dart:math';

class SpatialDbService {
  List<List<dynamic>> parseCsv(String csvString) {
    return const CsvToListConverter().convert(csvString);
  }

  void makeDb() async {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    String csvString = await rootBundle.loadString('data.csv');

    List<List<dynamic>> csvData = parseCsv(csvString);

    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

  await deleteDatabase(path);

    final rtreeDb = sqlite3.open(path);

    rtreeDb.execute('''
      CREATE VIRTUAL TABLE rtreeDb USING rtree(
        id, 
        minX, maxX, 
        minY, maxY,
        +name TEXT
        )''');

    final stmt = rtreeDb.prepare(
        'INSERT INTO rtreeDb (id, minX, maxX, minY, maxY, name) VALUES (?, ?, ?, ?, ?, ?)');
    for (int i = 0; i < csvData.length; i++) {

      var row = csvData[i];

      int id = int.parse(row[0]);
      String name = row[1];
      double lat = double.parse(row[2].toString()) / 1e7;
      double lon = double.parse(row[3].toString()) / 1e7;

      stmt.execute([
        id,
        lat,
        lat,
        lon,
        lon,
        name,
      ]);
    }
    stmt.dispose();

    // Close database
    rtreeDb.dispose();
  }

  void makeRtreeDb(List<CrossMapModel> data) async {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    var rtreeDbPath = await getDatabasesPath();
    String rtreePath = join(rtreeDbPath, 'rtree.db');

    await deleteDatabase(rtreePath);

    final rtreeDb = sqlite3.open(rtreePath);

    rtreeDb.execute('''
      CREATE VIRTUAL TABLE rtreeDb USING rtree(
        id, 
        minX, maxX, 
        minY, maxY,
        +name TEXT
        )''');

    final stmt = rtreeDb.prepare(
        'INSERT INTO rtreeDb (id, minX, maxX, minY, maxY, name) VALUES (?, ?, ?, ?, ?, ?)');
    for (int i = 0; i < data.length; i++) {
      var row = data[i];
      int id = row.id;
      double lon = row.mapLon / 1e7;
      double lat = row.mapLat / 1e7;
      String name = row.name;

      stmt.execute([
        id,
        lat,
        lat,
        lon,
        lon,
        name,
      ]);
    }
    stmt.dispose();

    // Close database
    rtreeDb.dispose();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // 지구 반지름 (미터)
    var phi1 = lat1 * pi / 180;
    var phi2 = lat2 * pi / 180;
    var deltaPhi = (lat2 - lat1) * pi / 180;
    var deltaLambda = (lon2 - lon1) * pi / 180;

    var a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // 미터 단위 거리 반환
  }

  Future<List<Map<String, dynamic>>> findIdsWithinArea(
      double myLat, double myLon, double length) async {
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();

    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'rtreeDb.db');

    final db = sqlite3.open(path);

    double latDiff = length /
        2 /
        calculateDistance(myLat, myLon, myLat + myLat < 0 ? 1 : -1, myLon);

    double lonDiff = length /
        2 /
        calculateDistance(myLat, myLon, myLat, myLon + myLon < 0 ? 1 : -1);

    double lat1 = myLat - (myLat < 0 ? 1 : -1 * latDiff);
    double lon1 = myLon - (myLon < 0 ? 1 : -1 * lonDiff);

    double lat2 = myLat + (myLat < 0 ? 1 : -1 * latDiff);
    double lon2 = myLon + (myLon < 0 ? 1 : -1 * lonDiff);

    final ResultSet resultSet = db.select('''
      SELECT * FROM rtreeDb
      WHERE minX >= ? AND maxX <= ? AND minY >= ? AND maxY <= ?
    ''', [lat2, lat1, lon2, lon1]);

    // print('diff $latDiff $lonDiff');

    // print('Lat and Lon $myLat $myLon');
    // print('findIds $lat1 $lat2 $lon1 $lon2');

    List<Map<String, dynamic>> results = [];
    for (final Row row in resultSet) {
      results.add({
        'id': row['id'],
        'minX': row['minX'],
        'maxX': row['maxX'],
        'minY': row['minY'],
        'maxY': row['maxY'],
        'name': row['name'],
      });
    }

    db.dispose();

    print('[SDB Time] ${stopwatch.elapsed}');
    stopwatch.stop();

    return results;
  }

  Future<void> printDb() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'rtreeDb.db');

    final db = sqlite3.open(path);

    var testValues = db.select("SELECT * FROM rtreeDb");
    for (var row in testValues) {
      print('Index: ${row['id']}, minX: ${row['minX']}, maxX: ${row['maxX']}');
    }
  }
}
