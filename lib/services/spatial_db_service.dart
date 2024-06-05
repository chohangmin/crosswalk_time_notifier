import 'dart:ffi';
import 'dart:io';

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

    final db = sqlite3.open(path);

    db.execute('''
      CREATE VIRTUAL TABLE crossInfo USING rtree(
        id, 
        minX, 
        maxX, 
        minY, 
        maxY);
    ''');

    final stmt = db.prepare(
        'INSERT INTO crossInfo (id, minX, maxX, minY, maxY) VALUES (?, ?, ?, ?, ?)');
    for (int i = 1; i < csvData.length; i++) {
      var row = csvData[i];
      String id = row[0].toString();
      double lat = double.parse(row[2].toString()) / 1e7;
      double lon = double.parse(row[3].toString()) / 1e7;

      stmt.execute([id, lat, lat, lon, lon]);
    }
    stmt.dispose();

    // Close database
    db.dispose();
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
    String path = join(databasePath, 'crossInfo.db');

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
      SELECT * FROM crossInfo
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
      });
    }

    db.dispose();

    print('[SDB Time] ${stopwatch.elapsed}');
    stopwatch.stop();

    return results;
  }

  Future<void> printDb() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    final db = sqlite3.open(path);

    var testValues = db.select("SELECT * FROM crossInfo");
    for (var row in testValues) {
      print('Index: ${row['id']}, minX: ${row['minX']}, maxX: ${row['maxX']}');
    }
  }

  Future<List<Map<String, dynamic>>> findNearest(
      double myLat, double myLon) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    final db = sqlite3.open(path);

    final ResultSet resultSet = db.select('''
      SELECT id, minX as lat, minY as lon,
      (
        (minX - ?) * (minX - ?) +
        (minY - ?) * (minY - ?)
      ) as dist
      FROM crossInfo
      ORDER BY dist ASC
      LIMIT 1
    ''', [myLat, myLat, myLon, myLon]);

    List<Map<String, dynamic>> result = [];
    for (final row in resultSet) {
      result.add({
        'id': row['id'],
        'lat': row['lat'],
        'lon': row['lon'],
        'dist': row['dist'],
      });
    }

    db.dispose();
    return result;
  }
}
