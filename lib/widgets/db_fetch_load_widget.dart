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
  bool _dataFetched = false;
  final bool _apiAvailable = false;
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
                    await dbApiService.getCrossMap();

                spatialDbService.makeRtreeDb(crossMaps);
              } else {
                spatialDbService.makeDb();
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
