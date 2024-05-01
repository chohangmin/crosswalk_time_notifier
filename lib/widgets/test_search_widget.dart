import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';
import 'package:crosswalk_time_notifier/services/api_service.dart';
import 'package:crosswalk_time_notifier/services/light_service.dart';
import 'package:crosswalk_time_notifier/services/locator_service.dart';
import 'package:crosswalk_time_notifier/services/search_service.dart';
import 'package:crosswalk_time_notifier/services/db_service.dart';
import 'package:crosswalk_time_notifier/widgets/api_time_widget.dart';
import 'package:crosswalk_time_notifier/widgets/current_time_widget.dart';
import 'package:crosswalk_time_notifier/widgets/light_widget.dart';
import 'package:crosswalk_time_notifier/widgets/traffic_signal_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  GeolocatorService geolocatorService = GeolocatorService();

  SearchService searchService = SearchService();

  DbService dbService = DbService();

  ApiService apiService = ApiService();

  LightService lightService = LightService();

  bool _searching = false;
  bool _searchingCompleted = false;
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
        searchingCompleted: _searchingCompleted,
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
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text('DB initialize.'),
        ),
        const PopupMenuItem(value: 2, child: Text('Start Searching.')),
        const PopupMenuItem(value: 3, child: Text('Pause Searching.'))
      ],
    );
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

    while (_searching) {
      await Future.delayed(const Duration(seconds: 1));

      Position? position = await geolocatorService.getCurrentPosition();
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
        _searchingState = 'Empty';
      } else if (filteredPositions.length == 1) {
        _searchingState = 'Searched 1';
        _searching = false;
        _searchingCompleted = true;
      } else {
        _searchingState = 'more than 1';
      }
    }
  }
}

class Page extends StatelessWidget {
  final bool searching;
  final bool searchingCompleted;
  final String searchingState;

  const Page({
    super.key,
    required this.searching,
    required this.searchingCompleted,
    required this.searchingState,
  });

  @override
  Widget build(BuildContext context) {
    if (!searching) {
      if (searchingState == 'Empty' || searchingState == 'more than 1') {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(searchingState),
            const CircularProgressIndicator(),
          ],
        );
      }
    }

    if (searching && searchingCompleted) {
      return Center(
        child: Text('$searchingState : find 1'),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
