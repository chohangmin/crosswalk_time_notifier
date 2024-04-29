import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';
import 'package:crosswalk_time_notifier/widgets/traffic_info_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TrafficSignalWidget extends StatefulWidget {
  const TrafficSignalWidget({super.key});

  @override
  _TrafficSignalWidgetState createState() => _TrafficSignalWidgetState();
}

class _TrafficSignalWidgetState extends State<TrafficSignalWidget> {
  final data = [
    const TrafficInfo(name: '1', isMovementAllowed: true, time: 10.0),
    const TrafficInfo(name: '2', isMovementAllowed: false, time: 20.0),
    const TrafficInfo(name: '3', isMovementAllowed: true, time: 15.0),
    const TrafficInfo(name: '4', isMovementAllowed: false, time: 25.0),
    const TrafficInfo(name: '5', isMovementAllowed: true, time: 12.0),
    const TrafficInfo(name: '6', isMovementAllowed: false, time: 18.0),
    const TrafficInfo(name: '7', isMovementAllowed: true, time: 22.0),
    const TrafficInfo(name: '8', isMovementAllowed: false, time: 27.0),
    const TrafficInfo(name: '9', isMovementAllowed: true, time: 10.0),
    const TrafficInfo(name: '10', isMovementAllowed: false, time: 20.0),
    const TrafficInfo(name: '11', isMovementAllowed: true, time: 15.0),
    const TrafficInfo(name: '12', isMovementAllowed: false, time: 25.0),
    const TrafficInfo(name: '13', isMovementAllowed: true, time: 12.0),
    const TrafficInfo(name: '14', isMovementAllowed: false, time: 18.0),
    const TrafficInfo(name: '15', isMovementAllowed: true, time: 22.0),
    const TrafficInfo(name: '16', isMovementAllowed: false, time: 27.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Stack(
              children: List.generate(16, (index) {
                final angle = index * (2 * pi / 16) + pi / 2 * 3;
                final x = 150 + 120 * cos(angle);
                final y = 150 + 120 * sin(angle);

                return Positioned(
                  left: x - 30,
                  top: y - 15,
                  child: TrafficInfo(
                    name: data[index].name,
                    isMovementAllowed: data[index].isMovementAllowed,
                    time: data[index].time,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
