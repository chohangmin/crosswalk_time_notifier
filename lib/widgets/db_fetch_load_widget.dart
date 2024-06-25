import 'package:crosswalk_time_notifier/models/cross_map_model.dart';
import 'package:crosswalk_time_notifier/screens/main_screen.dart';
import 'package:crosswalk_time_notifier/services/db_api_service.dart';
import 'package:crosswalk_time_notifier/services/spatial_db_service.dart';
import 'package:flutter/material.dart';

class DbFetchLoadWidget extends StatefulWidget {
  const DbFetchLoadWidget({super.key});

  @override
  State<DbFetchLoadWidget> createState() => _DbFetchLoadWidgetState();
}

class _DbFetchLoadWidgetState extends State<DbFetchLoadWidget> {

  bool _dataFetched = false; // If data fetched, load main screen widget
  final bool _apiAvailable = false; // Current fetch api is not available, If false get local Cross info data

  @override
  Widget build(BuildContext context) {
    if (!_dataFetched) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              SpatialDbService spatialDbService = SpatialDbService();
              if (_apiAvailable) {
                DbApiService dbApiService = DbApiService();

                await dbApiService.setApiKey();
                List<CrossMapModel> crossMaps =
                    await dbApiService.getCrossMap(); // Get api data

                spatialDbService.makeDbFromApi(crossMaps); // Make rtree db using api data 
              } else {
                spatialDbService.makeDbFromCsv(); // Make rtree db using local csv data
              }

              setState(() {
                _dataFetched = !_dataFetched;
              });
            },
            child: const Text('Data Fetch & Load'),
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(child: MainScreen()),
      );
    }
  }
}
