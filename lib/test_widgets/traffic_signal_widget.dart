import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';
import 'package:crosswalk_time_notifier/test_widgets1/traffic_info_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TrafficSignalWidget extends StatefulWidget {
  const TrafficSignalWidget({super.key, required this.data});
  final List<TrafficInfoModel> data;

  @override
  _TrafficSignalWidgetState createState() => _TrafficSignalWidgetState();
}

class _TrafficSignalWidgetState extends State<TrafficSignalWidget> {
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
              children: List.generate(8, (index) {
                final angle = index * (2 * pi / 16) + pi * 3 / 2 - pi * 1 / 16;
                final x = 150 + 120 * cos(angle);
                final y = 150 + 120 * sin(angle);

                return Positioned(
                  left: x - 30,
                  top: y - 15,
                  child: TrafficInfo(
                    name: widget.data[index].name,
                    isMovementAllowed: widget.data[index].isMovementAllowed,
                    time: widget.data[index].time,
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
