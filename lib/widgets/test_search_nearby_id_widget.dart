import 'package:crosswalk_time_notifier/services/locator_service.dart';
import 'package:crosswalk_time_notifier/services/search_service.dart';
import 'package:crosswalk_time_notifier/services/db_service.dart';
import 'package:crosswalk_time_notifier/widgets/request_info_api_widget.dart';
import 'package:crosswalk_time_notifier/widgets/test_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:crosswalk_time_notifier/services/spatial_db_service.dart';

class TestSearchNearbyIdWidget extends StatefulWidget {
  const TestSearchNearbyIdWidget({super.key});

  @override
  State<TestSearchNearbyIdWidget> createState() =>
      _TestSearchNearbyIdWidgetState();
}

class _TestSearchNearbyIdWidgetState extends State<TestSearchNearbyIdWidget> {
  final GeolocatorService geolocatorService =
      GeolocatorService(); // Service that returns current location, latitude, longitude

  final SpatialDbService spatialDbSerive = SpatialDbService();

  bool _searching = false; // Flag indicating if a search is in progress
  bool _dbInit = false; // Flag indicating if the database is initialized
  bool _searchingCompleted =
      false; // Flag indicating if the search is completed
  String _searchingState = ''; // Current state of the search result

  // late TestShowLightWidget _testShowLightWidget;
  String id = '';

  @override
  Widget build(BuildContext context) {
    debugDumpFocusTree();
    return Scaffold(
      appBar: AppBar(
        title: const Text('CrossWalk Time Notifier.'),
        actions: [_createActions()],
      ),
      body: Center(
        child: _searching
            ? (_searchingCompleted
                ? Column(
                    mainAxisSize: MainAxisSize.min,

                    // if searching, searchingCompleted is T, T means there is a cross id from nearby user's location.
                    children: [
                      // TestTime(
                      //     id: id), // Go to show light widget that request api servies, and must needed id.
                      Flexible(
                        fit: FlexFit.loose,
                        child: RequestInfoApiWidget(id: id),
                      ),
                      Builder(builder: (context) {
                        debugDumpRenderTree();
                        return const SizedBox.shrink();
                      }),
                      const Text('Success Loading')
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
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
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

      Position? position = await geolocatorService
          .getCurrentPosition(); // 1. Find my location latitude, longitude.
      if (position == null) {
        throw Exception('Failed to retrieve current position.');
      }

      List<Map<String, dynamic>> results =
          await spatialDbSerive.findIdsWithinArea(
        position.latitude,
        position.longitude,
        1000,
      ); // 1km

      if (results.isEmpty) {
        // 3 - 1. Searched location is 0, there is no cross id in that area.
        setState(() {
          _searchingState = 'Empty';
        });
      } else if (results.length == 1) {
        // 3 - 2. Searched location is 1, Successful!
        String id = results[0]['id'].toString();
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

        print('[TIMET] ${stopwatch.elapsed}');
        stopwatch.stop();
      } else {
        setState(() {
          _searchingState =
              'more than 1'; // 3 - 2. Searched location is more than 1, there is so many cross id.
        });
      }
    });
  }

  PopupMenuButton _createActions() {
    // Popup menu, if _dbInit is false there is one option, Db initialize.
    return PopupMenuButton(
        // If _dbInit is true, there is two options, startSearching and pauseSearching.
        elevation: 40,
        onSelected: (value) async {
          switch (value) {
            case 1:
              spatialDbSerive.makeDb();
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
}
