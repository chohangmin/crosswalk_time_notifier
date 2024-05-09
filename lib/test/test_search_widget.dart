import 'package:crosswalk_time_notifier/services/locator_service.dart';
import 'package:crosswalk_time_notifier/services/search_service.dart';
import 'package:crosswalk_time_notifier/services/db_service.dart';
import 'package:crosswalk_time_notifier/test/test_show_light_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class TestSearchWidget extends StatefulWidget {
  const TestSearchWidget({super.key});

  @override
  State<TestSearchWidget> createState() => _TestSearchWidgetState();
}

class _TestSearchWidgetState extends State<TestSearchWidget> {
  final GeolocatorService geolocatorService = GeolocatorService();
  final SearchService searchService = SearchService();
  final DbService dbService = DbService();

  bool _searching = false;
  bool _dbInit = false;
  bool _searchingCompleted = false;
  String _searchingState = '';
  late TestShowLightWidget _testShowLightWidget;

  PopupMenuButton _createActions() {
    return PopupMenuButton(
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
                ? const Text('searching id only 1!')
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

      Position? position = await geolocatorService.getCurrentPosition();
      if (position == null) {
        throw Exception('Failed to retrieve current position.');
      }
      final List<Map<String, dynamic>> coordinates = await dbService.getAllow();

      final filteredPositions = searchService.filterCoordinates(
        coordinates,
        0.5,
        position.latitude,
        position.longitude,
      );

      if (filteredPositions.isEmpty) {
        setState(() {
          _searchingState = 'Empty';
        });
      } else if (filteredPositions.length == 1) {
        String id = filteredPositions[0]['id'].toString();
        _testShowLightWidget = TestShowLightWidget(id: id);

        setState(() {
          timer.cancel();
          _searchingState = 'Searched 1';
          _searchingCompleted = true;
          _searching = false;
        });
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => _testShowLightWidget));
      } else {
        setState(() {
          _searchingState = 'more than 1';
        });
      }
    });
  }
}
