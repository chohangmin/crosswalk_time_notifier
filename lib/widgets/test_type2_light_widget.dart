import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';
import 'package:crosswalk_time_notifier/widgets/traffic_info_widget.dart';

class TestType2LightWidget extends StatelessWidget {
  final List<TrafficInfoModel> data;

  const TestType2LightWidget({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: TrafficInfo(
                name: data[index].name,
                isMovementAllowed: data[index].isMovementAllowed,
                time: data[index].time,
              ),
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: TrafficInfo(
                name: data[index + 3].name,
                isMovementAllowed: data[index + 3].isMovementAllowed,
                time: data[index + 3].time,
              ),
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: TrafficInfo(
                name: data[index + 3].name,
                isMovementAllowed: data[index + 3].isMovementAllowed,
                time: data[index + 3].time,
              ),
            );
          }),
        ),
      ],
    );
  }
}
