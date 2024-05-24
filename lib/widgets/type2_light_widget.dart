import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';
import 'package:crosswalk_time_notifier/test_widgets/traffic_info_widget.dart';

class Type2LightWidget extends StatelessWidget {
  final List<TrafficInfoModel> data;

  const Type2LightWidget({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start(); // Stopwatch 시작

    print("[TYPE] 2");
    print(data);

    Widget widget = Column(
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
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TrafficInfo(
                name: data[3].name,
                isMovementAllowed: data[3].isMovementAllowed,
                time: data[3].time,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child:
                  TrafficInfo(name: "Middle", isMovementAllowed: null, time: 0),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TrafficInfo(
                name: data[4].name,
                isMovementAllowed: data[4].isMovementAllowed,
                time: data[4].time,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: TrafficInfo(
                name: data[index + 5].name,
                isMovementAllowed: data[index + 5].isMovementAllowed,
                time: data[index + 5].time,
              ),
            );
          }),
        ),
      ],
    );

    stopwatch.stop();
    print("[TYPE2 TIME] ${stopwatch.elapsed}");

    return widget;

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: List.generate(3, (index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(8),
    //           child: TrafficInfo(
    //             name: data[index].name,
    //             isMovementAllowed: data[index].isMovementAllowed,
    //             time: data[index].time,
    //           ),
    //         );
    //       }),
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(8),
    //           child: TrafficInfo(
    //             name: data[3].name,
    //             isMovementAllowed: data[3].isMovementAllowed,
    //             time: data[3].time,
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8),
    //           child:
    //               TrafficInfo(name: "Middle", isMovementAllowed: null, time: 0),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8),
    //           child: TrafficInfo(
    //             name: data[4].name,
    //             isMovementAllowed: data[4].isMovementAllowed,
    //             time: data[4].time,
    //           ),
    //         ),
    //       ],
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: List.generate(3, (index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(8),
    //           child: TrafficInfo(
    //             name: data[index + 5].name,
    //             isMovementAllowed: data[index + 5].isMovementAllowed,
    //             time: data[index + 5].time,
    //           ),
    //         );
    //       }),
    //     ),
    //   ],
    // );
  }
}