import 'package:crosswalk_time_notifier/models/cross_map_model.dart';
import 'package:crosswalk_time_notifier/screens/main_screen.dart';
import 'package:crosswalk_time_notifier/services/db_api_service.dart';
import 'package:crosswalk_time_notifier/services/spatial_db_service.dart';
import 'package:flutter/material.dart';

class DbFetchLoadWidget extends StatelessWidget {
  const DbFetchLoadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () async {
          DbApiService dbApiService = DbApiService();
          SpatialDbService spatialDbService = SpatialDbService();

          await dbApiService.setApiKey();
          List<CrossMapModel> crossMaps = await dbApiService.getCrossMap();

          spatialDbService.makeRtreeDb(crossMaps);

          const MainScreen();
        },
        child: const Text('Data Fetch & Load'),
      ),
    );
  }
}
