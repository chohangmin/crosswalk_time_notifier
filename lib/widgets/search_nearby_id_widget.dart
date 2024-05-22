import 'package:crosswalk_time_notifier/services/locator_service.dart';
import 'package:crosswalk_time_notifier/services/search_service.dart';
import 'package:crosswalk_time_notifier/services/db_service.dart';
import 'package:crosswalk_time_notifier/widgets/request_info_api_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class SearchNearbyIdWidget extends StatefulWidget {
  const SearchNearbyIdWidget({super.key});

  @override
  State<SearchNearbyIdWidget> createState() => _SearchNearbyIdWidgetState();
}

class _SearchNearbyIdWidgetState extends State<SearchNearbyIdWidget> {
  final GeolocatorService geolocatorService = GeolocatorService();
  final SearchService searchService = SearchService();
  final DbService dbService = DbService();

  bool _searching = false;
  bool _dbInit = false;
  bool _searchingCompleted = false;
  String _searchingState = '';
  // late TestShowLightWidget _testShowLightWidget;
  String id = '';

  PopupMenuButton _createActions() { // Popup menu, if _dbInit is false there is one option, Db initialize.
    return PopupMenuButton(          // If _dbInit is true, there is two options, startSearching and pauseSearching.
        elevation: 40,
        onSelected: (value) async {
          switch (value) {
            case 1:
              dbService.makeDb();
              setState(() {
                _dbInit = true;
              });

              break;
            case 2:
              _startSearching();
              break;
            case 3:
              _pauseSearching();
              break;
            default:
              break;
          }
        },
        itemBuilder: (context) {
          if (!_dbInit) {
            return [
              const PopupMenuItem(value: 1, child: Text('DB initialize.'))
            ];
          } else {
            return [
              const PopupMenuItem(value: 2, child: Text('Start Searching.')),
              const PopupMenuItem(value: 3, child: Text('Pause Searching.'))
            ];
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CrossWalk Time Notifier.'),
        actions: [_createActions()],
      ),
      body: Center(
        child: _searching
            ? (_searchingCompleted
                ?  Column( // if searching, searchingCompleted is T, T means there is a cross id from nearby user's location.
                    children: [
                      RequestInfoApiWidget(id: id), // Go to show light widget that request api servies, and must needed id.
                      Text('Success Loading')
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      Text(_searchingState),
                    ],
                  ))
            : Center(
                child: Text('default Screen \n String : $_searchingState'),
              ),
      ),
    );
  }

  void _pauseSearching() {
    setState(() {
      _searching = false;
    });
  }

  void _startSearching() async {
    setState(() {
      if (_searchingCompleted == false) {
        _searching = true;
      } else {
        _searching = true;
        _searchingCompleted = false;
      }
    });

    int i = 0;

    Timer.periodic(const Duration(seconds: 4), (timer) async {
      print(i++);

      Position? position = await geolocatorService.getCurrentPosition(); // 1. Find my location latitude, longitude.
      if (position == null) {
        throw Exception('Failed to retrieve current position.');
      }
      final List<Map<String, dynamic>> coordinates = await dbService.getAllow(); // 2. If Db is init, get all data's from Db

      final filteredPositions = searchService.filterCoordinates( // 3. Searching user's nearby cross id.
        coordinates,
        0.5,
        position.latitude,
        position.longitude,
      );

      if (filteredPositions.isEmpty) { // 3 - 1. Searched location is 0, there is no cross id in that area.
        setState(() {
          _searchingState = 'Empty';
        });
      } else if (filteredPositions.length == 1) { // 3 - 2. Searched location is 1, Successful!
        String id = filteredPositions[0]['id'].toString();
        // _testShowLightWidget = TestShowLightWidget(id: id);

        setState(() {
          timer.cancel();
          _searchingState = 'Searched 1';
          _searchingCompleted = true;
          _searching = true;
          this.id = id;
        });
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => _testShowLightWidget));
      } else {
        setState(() {
          _searchingState = 'more than 1'; // 3 - 2. Searched location is more than 1, there is so many cross id.
        });
      }
    });
  }
}
