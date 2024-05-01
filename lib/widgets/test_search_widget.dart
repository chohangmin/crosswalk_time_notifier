import 'package:crosswalk_time_notifier/services/locator_service.dart';
import 'package:crosswalk_time_notifier/services/search_service.dart';
import 'package:crosswalk_time_notifier/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TestSearchWidget extends StatefulWidget {
  const TestSearchWidget({super.key});

  @override
  State<TestSearchWidget> createState() => _TestSearchWidgetState();
}

class _TestSearchWidgetState extends State<TestSearchWidget> {
  GeolocatorService geolocatorService = GeolocatorService();

  SearchService searchService = SearchService();

  DbService dbService = DbService();

  bool _searching = false;
  bool _dbInit = false;
  String _searchingState = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CrossWalk Time Notifier.'),
        actions: [_createActions()],
      ),
      body: Page(
        searching: _searching,
        searchingState: _searchingState,
      ),
    );
  }

  PopupMenuButton _createActions() {
    return PopupMenuButton(
        elevation: 40,
        onSelected: (value) async {
          switch (value) {
            case 1:
              dbService.makeDb();
              _dbInit = !_dbInit;

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

  void _pauseSearching() {
    setState(() {
      _searching = false;
    });
  }

  void _startSearching() async {
    setState(() {
      _searching = true;
    });

    int i = 0;

    while (_searching) {
      await Future.delayed(const Duration(seconds: 1));

      print(i++);

      Position? position = await geolocatorService.getCurrentPosition();
      if (position == null) {
        throw Exception('Failed to retrieve current position.');
      }
      final List<Map<String, dynamic>> coordinates = await dbService.getAllow();

      final filteredPositions = searchService.filterCoordinates(
        coordinates,
        0,
        position.latitude,
        position.longitude,
      );

      if (filteredPositions.isEmpty) {
        setState(() {
          _searchingState = 'Empty';
        });
      } else if (filteredPositions.length == 1) {
        setState(() {
          _searchingState = 'Searched 1';
          _searching = false;
        });
      } else {
        setState(() {
          _searchingState = 'more than 1';
        });
      }
    }
  }
}

class Page extends StatelessWidget {
  final bool searching;
  final String searchingState;

  const Page({
    super.key,
    required this.searching,
    required this.searchingState,
  });

  @override
  Widget build(BuildContext context) {
    if (searchingState == 'Empty' || searchingState == 'more than 1') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(searchingState),
            const CircularProgressIndicator(),
          ],
        ),
      );
    }

    if (searchingState == 'Searched 1') {
      return Center(
        child: Text('$searchingState : find 1'),
      );
    }
    if (!searching && searchingState.isEmpty) {
      return const Center(
        child: Text('first screen.'),
      );
    }

    return const Center(
      child: Text('nothing'),
    );
  }
}
