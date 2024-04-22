import 'package:crosswalk_time_notifier/services/api_service.dart';
import 'package:crosswalk_time_notifier/services/locator_service.dart';
import 'package:crosswalk_time_notifier/services/search_service.dart';
import 'package:crosswalk_time_notifier/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({super.key});

  GeolocatorService geolocatorService = GeolocatorService();
  SearchService searchService = SearchService();
  DbService dbService = DbService();
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Positions'),
      ),
      body: FutureBuilder(
          future: searchPositions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}.'));
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text('Failed to load data.'),
              );
            }
            final filteredPositions = snapshot.data!;
            return ListView.builder(
              itemCount: filteredPositions.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> position = filteredPositions[index];
                return ListTile(
                  title: Text(
                      'ID: ${position['id']} Name: ${position['name']}, Latitude: ${position['lat']}, Longtitude: ${position['lon']}'),
                );
              },
            );
          }),
    );
  }

  Future<List<Map<String, dynamic>>?> searchPositions() async {
    Position? position = await geolocatorService.getCurrentPosition();
    print('hello');

    if (position == null) {
      throw Exception('Failed to retrieve current position.');
    }

    final List<Map<String, dynamic>> coordinates = await dbService.getAllow();

    final filteredPositions = searchService.filterCoordinates(
      coordinates,
      0.3,
      position.latitude,
      position.longitude,
    );

    if (filteredPositions.isEmpty) {
    } else if (filteredPositions.length == 1) {
      String id = filteredPositions[0]['id'].toString();
      apiService.setId(id);
    } else if (filteredPositions.length == 2) {
      String id = filteredPositions[0]['id'].toString();
      apiService.setId(id);
      await apiService.initialize();
      await apiService.getRemainTimes();
      await apiService.getSignalInfo();
      return filteredPositions;
    } else {}

    return filteredPositions;
  }
}
