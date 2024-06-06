import 'package:crosswalk_time_notifier/services/api_service.dart';
import 'package:crosswalk_time_notifier/services/light_service.dart';
import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';

import 'package:flutter/material.dart';

class TestTime extends StatefulWidget {
  final String id;

  const TestTime({super.key, required this.id});

  @override
  State<TestTime> createState() => _TestTimeState();
}

class _TestTimeState extends State<TestTime> {
  ApiService apiService = ApiService();
  LightService lightService = LightService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getApiInstances(),
        builder: (context, snapshot) {
          Stopwatch stopwatch = Stopwatch();
          stopwatch.start();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List responses = snapshot.data!;

            DateTime now = DateTime.now();
            DateTime currentTimeRT = DateTime.fromMillisecondsSinceEpoch(
                responses[0].trsmUtcTime.toInt());
            DateTime currentTimeSI = DateTime.fromMillisecondsSinceEpoch(
                responses[1].trsmUtcTime.toInt());
            return Column(
              children: [
                Text('$now'),
                Text('RT $currentTimeRT'),
                Text('SI $currentTimeSI'),
              ],
            );
          }
        });
  }

  Future<List> getApiInstances() async {
    await apiService.setApiKey(); // set API key
    apiService.setId(widget.id); // set API id

    // final Future<RemainTimeModel?> rtFuture = apiService.getRemainTime();
    // final Future<SignalInfoModel?> siFuture = apiService.getSignalInfo();

    // final List responses = await Future.wait([rtFuture, siFuture]);

    RemainTimeModel? filteredRT = await apiService.getRemainTime();
    SignalInfoModel? filteredSI = await apiService.getSignalInfo();

    List responses = [filteredRT, filteredSI];

    return responses;
  }
}
