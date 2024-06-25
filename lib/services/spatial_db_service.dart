import 'package:crosswalk_time_notifier/models/cross_map_model.dart';
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

  void makeDbFromCsv() async {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    String csvString = await rootBundle.loadString('data.csv'); // Set csv data path
    List<List<dynamic>> csvData = parseCsv(csvString); // Get csv data 

    var databasePath = await getDatabasesPath(); // Get Db path
    String path = join(databasePath, 'rtreeDb.db'); // Set Db path
    await deleteDatabase(path); // If Db is exist, Delete it for new one

    final rtreeDb = sqlite3.open(path); // Open Db using Sqlite3

    rtreeDb.execute('''
      CREATE VIRTUAL TABLE rtreeDb USING rtree(
        id, 
        minX, maxX, 
        minY, maxY,
        +name TEXT
        )'''); // If you want to use rtree in Sqlite3, 1D need 3 values (id, minX, maxX), 2D need 5, 3D need 7 ...
               // Additional field needs + before the variable

    final stmt = rtreeDb.prepare(
        'INSERT INTO rtreeDb (id, minX, maxX, minY, maxY, name) VALUES (?, ?, ?, ?, ?, ?)');

    for (int i = 1; i < csvData.length; i++) { // Index = 0 is columns name, so start in 1

      var row = csvData[i];

      int id = int.parse(row[0].toString()); // Cross's Id
      String name = row[1]; // Cross's name
      double lat = double.parse(row[2].toString()) / 1e7; // Cross's latitude
      double lon = double.parse(row[3].toString()) / 1e7; // Cross's longitude

      stmt.execute([
        id,
        lon,
        lon,
        lat,
        lat,
        name,
      ]);
    }
    stmt.dispose();

    rtreeDb.dispose(); // Close Db
  }

  void makeDbFromApi(List<CrossMapModel> data) async { // Similar to makeDbFromCsv but this method needs parameter of data

    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    var rtreeDbPath = await getDatabasesPath();
    String rtreePath = join(rtreeDbPath, 'rtreeDb.db');

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
        lon,
        lon,
        lat,
        lat,
        name,
      ]);
    }
    stmt.dispose();

    rtreeDb.dispose();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {

    const R = 6371e3; // earth R (m)
    var phi1 = lat1 * pi / 180;
    var phi2 = lat2 * pi / 180;

    var deltaPhi = (lat2 - lat1) * pi / 180;
    var deltaLambda = (lon2 - lon1) * pi / 180;

    var a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // return (m)
  }

  Future<List<Map<String, dynamic>>> findIdsWithinArea(
      double myLon, double myLat, double length) async {


    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'rtreeDb.db');

    final db = sqlite3.open(path);

    double latDiff = length /
        2 /
        calculateDistance(myLat, myLon, myLat + myLat < 0 ? 1 : -1, myLon); // Convert half square distance to Latitude 

    double lonDiff = length /
        2 /
        calculateDistance(myLat, myLon, myLat, myLon + myLon < 0 ? 1 : -1); // Convert half square distance to Longitude

    double lat1 = myLat - (myLat < 0 ? 1 : -1 * latDiff); 
    double lon1 = myLon - (myLon < 0 ? 1 : -1 * lonDiff);

    double lat2 = myLat + (myLat < 0 ? 1 : -1 * latDiff);
    double lon2 = myLon + (myLon < 0 ? 1 : -1 * lonDiff);

    // Get square min Lat, Lon and max Lat, Lon

    final ResultSet resultSet = db.select('''
      SELECT * FROM rtreeDb
      WHERE minX >= ? AND maxX <= ? AND minY >= ? AND maxY <= ?
    ''', [lon2, lon1, lat2, lat1]);

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

    return results; // Return selected values
  }
}
