import 'package:crosswalk_time_notifier/services/api_service.dart';
import 'package:crosswalk_time_notifier/services/light_service.dart';
import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';
import 'package:crosswalk_time_notifier/test/test_type1_light_widget.dart';
import 'package:crosswalk_time_notifier/test/test_type2_light_widget.dart';
import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/widgets/api_time_widget.dart';
import 'package:crosswalk_time_notifier/widgets/current_time_widget.dart';
import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';

class TestShowLightWidget extends StatefulWidget {
  final String id;

  TestShowLightWidget({super.key, required this.id});

  @override
  State<TestShowLightWidget> createState() => _TestShowLightWidgetState();
}

class _TestShowLightWidgetState extends State<TestShowLightWidget> {
  ApiService apiService = ApiService();

  LightService lightService = LightService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getApiInstances(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List responses = snapshot.data!;
            lightService.setApiInstances(responses[0], responses[1]);
            lightService.printApiInstances();
            final signals = lightService.getSignalLists();
            final rtUtcTime = lightService.getRTUtcTime();
            final siUtcTime = lightService.getSIUtcTime();

            return FutureBuilder(
                future: _buildWidgetBasedOnApiType(responses, signals),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: [
                        const CurrentTimeWidget(),
                        ApiTimeWidget(name: 'RT', utcTime: rtUtcTime),
                        ApiTimeWidget(name: 'SI', utcTime: siUtcTime),
                        snapshot.data!
                      ],
                    );
                  }
                });
          }
        });
  }

  Future<List> getApiInstances() async {
    await apiService.setApiKey();
    apiService.setId(widget.id);
    // final Future<RemainTimeModel?> rtFuture = apiService.getRemainTime();
    // final Future<SignalInfoModel?> siFuture = apiService.getSignalInfo();

    // final List responses = await Future.wait([rtFuture, siFuture]);
 

    RemainTimeModel? filteredRT = await apiService.getRemainTime();

    SignalInfoModel? filteredSI = await apiService.getSignalInfo();

    List responses = [filteredRT, filteredSI];
   

    return responses;
  }

  Future<bool> checkApiAndType() async {
    if (lightService.checkApiInstances()) {
      return lightService.checkLightType();
    } else {
      throw Exception('API instances are not valid.');
    }
  }

  Future<Widget> _buildWidgetBasedOnApiType(
      List responses, List<TrafficInfoModel> signals) async {
    bool type = await checkApiAndType();

    if (type) {
      return Future.value(TestType1LightWidget(data: signals));
    } else {
      return Future.value(TestType2LightWidget(data: signals));
    }
  }
}
