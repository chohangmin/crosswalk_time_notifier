import 'package:crosswalk_time_notifier/services/api_service.dart';
import 'package:crosswalk_time_notifier/services/light_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestShowWidget extends StatelessWidget {
  final String id;
  ApiService apiService = ApiService();
  LightService lightService = LightService();

  TestShowWidget({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

Future<void> getApiInstances() async {
  await apiService.setApiKey();
  apiService.setId(id);
  RemainTimeModel RT = apiService.getRemainTime();
  SignalInfoModel SI = apiService.getSignalInfo();
  lightService.setApiInstances(RT, SI);
}
