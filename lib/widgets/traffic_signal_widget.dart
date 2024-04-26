import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';
import 'package:crosswalk_time_notifier/widgets/traffic_info_widget.dart';

class TrafficSignal extends StatelessWidget {
  const TrafficSignal({super.key});

  @override
  Widget build(BuildContext context) {
    // TrafficSignalData 인스턴스 생성
    final northData = TrafficInfoData(
      name: 'North',
      isMovementAllowed: true,
      time: 10.0,
    );
    final southData = TrafficInfoData(
      name: 'South',
      isMovementAllowed: false,
      time: 20.0,
    );
    final eastData = TrafficInfoData(
      name: 'East',
      isMovementAllowed: true,
      time: 15.0,
    );
    final westData = TrafficInfoData(
      name: 'West',
      isMovementAllowed: false,
      time: 25.0,
    );

//     상단 2줄은 북쪽과 남쪽 방향의 신호등입니다.
// 3번째와 4번째 줄은 북동, 동남, 남서, 북서 방향의 신호등입니다.
// 5번째와 6번째 줄은 동쪽과 서쪽 방향의 신호등입니다.
// 7번째와 8번째 줄은 북동, 동남, 남서, 북서 방향의 신호등입니다.
// 9번째와 10번째 줄은 북동, 동남 방향의 신호등입니다.
// 11번째와 12번째 줄은 남서, 북서 방향의 신호등입니다.

    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TrafficInfo(
              name: northData.name,
              isMovementAllowed: northData.isMovementAllowed,
              time: northData.time,
            ),
            TrafficInfo( name: southData.name,
              isMovementAllowed: southData.isMovementAllowed,
              time: southData.time,),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TrafficInfo(value: signalValues[2]),
            TrafficInfo(value: signalValues[3]),
            TrafficInfo(value: signalValues[4]),
            TrafficInfo(value: signalValues[5]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TrafficInfo(value: signalValues[0]),
            TrafficInfo(value: signalValues[1]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TrafficInfo(value: signalValues[2]),
            TrafficInfo(value: signalValues[3]),
            TrafficInfo(value: signalValues[4]),
            TrafficInfo(value: signalValues[5]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TrafficInfo(value: signalValues[0]),
            TrafficInfo(value: signalValues[1]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TrafficInfo(value: signalValues[0]),
            TrafficInfo(value: signalValues[1]),
          ],
        ),
      ],
    );
  }
}

