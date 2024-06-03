import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:csv/csv.dart';
import 'dart:math';

class SpatialDbService {
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
      double lat = double.parse(row[2].toString()) / 1e7;
      double lon = double.parse(row[3].toString()) / 1e7;

      batch.insert('crossInfo', {
        'id': id,
        'minX': lat,
        'maxX': lat,
        'minY': lon,
        'maxY': lon,
      });
    }
    await batch.commit();
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

  Future<List<Map<String, dynamic>>> findNearest(
      double myLat, double myLon) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    Database database = await openDatabase(path);

    List<Map<String, dynamic>> result = await database.rawQuery('''
      SELECT id, minX as lat, minY as lon,
      (
        (minX - ?) * (minX - ?) +
        (minY - ?) * (minY - ?)
      ) as dist
      FROM crossInfo
      ORDER BY dist ASC
      LIMIT 1
    ''', [myLat, myLat, myLon, myLon]);

    return result;
  }

  Future<Map<String, dynamic>> findNearest1(double myLat, double myLon) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crossInfo.db');

    Database database = await openDatabase(path);

    // 모든 시설물을 불러온 후 거리를 계산하고, 가장 가까운 시설물을 찾는 방식
    List<Map<String, dynamic>> result = await database.rawQuery('''
      SELECT id, minX as lat, minY as lon
      FROM crossInfo
    ''');

    // 거리를 계산하여 가장 가까운 시설물을 찾음
    Map<String, dynamic> nearest = result.first;
    double minDistance =
        calculateDistance(myLat, myLon, nearest['lat'], nearest['lon']);

    for (var row in result) {
      double distance = calculateDistance(myLat, myLon, row['lat'], row['lon']);
      if (distance < minDistance) {
        nearest = row;
        minDistance = distance;
      }
    }

    nearest['distance'] = minDistance; // 추가: 거리를 포함시킴
    return nearest;
  }
}
