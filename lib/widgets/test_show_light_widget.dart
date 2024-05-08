import 'package:crosswalk_time_notifier/services/api_service.dart';
import 'package:crosswalk_time_notifier/services/light_service.dart';
import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestShowLightWidget extends StatelessWidget {
  final String id;
  ApiService apiService = ApiService();
  LightService lightService = LightService();

  TestShowLightWidget({super.key, required this.id});
  // @override
  // Widget build(BuildContext context) {
  //   List responses = getApiInstances();

  //   return const Scaffold(
  //     if (checkApiAndType(responses[0], responses[1])) {
  //       return TestType1LightWidget();
  //     } else {
  //       return TestType2ListWidget();
  //     }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getApiInstances(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List responses = snapshot.data!;
            bool apiAndTypeCheck
          }
        });
  }

  Future<List> getApiInstances() async {
    await apiService.setApiKey();
    apiService.setId(id);
    final Future<RemainTimeModel?> rtFuture = apiService.getRemainTime();
    final Future<SignalInfoModel?> siFuture = apiService.getSignalInfo();

    final List responses = await Future.wait([rtFuture, siFuture]);

    return responses;
  }



  Future<bool> checkApiAndType(rt, si) async {
    lightService.setApiInstances(rt, si);
    if (lightService.checkApiInstances()) {
      return lightService.checkLightType();
    } else {
      print("Error and stop the application.");
      throw Exception('API instances are not valid.');
    }
  }

  Widget _buildWidgetBasedOnApiType(List responses) {
    bool? type = checkApiAndType(responses);
  }
}
