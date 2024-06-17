import 'dart:async';

import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LightWidget extends StatefulWidget {
  final String name;
  bool? isMovementAllowed;
  double? time;

  LightWidget({
    super.key,
    required this.name,
    required this.isMovementAllowed,
    required this.time,
  });

  @override
  State<LightWidget> createState() => _LightWidgetState();
}

class _LightWidgetState extends State<LightWidget> {
  late Timer _timer;
  int? _remainTime;

  @override
  void initState() {
    super.initState();
    _remainTime = widget.time?.toInt();
    if (_remainTime != null) {
      startTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainTime! >= 0) {
          _remainTime = _remainTime! - 1;
        } else {
          _timer.cancel();
          if (widget.isMovementAllowed != null) {
            widget.isMovementAllowed = !widget.isMovementAllowed!;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isMovementAllowed == null
              ? Colors.grey
              : (widget.isMovementAllowed! ? Colors.green : Colors.red)),
      child: Stack(
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                  text:
                      '${widget.name} \n ${((_remainTime ?? 0) ~/ 10).toInt()}',
                  style: const TextStyle(
                    fontSize: 10,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
