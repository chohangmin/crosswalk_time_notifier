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
  Timer? _timer;
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
        if (_remainTime! <= 0) {
          _timer?.cancel();

          widget.isMovementAllowed = !widget.isMovementAllowed!;
          // _remainTime = 0;
        } else {
          _remainTime = _remainTime! - 10;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(LightWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('[WIDGET UPDATE]');

    if (widget.name != oldWidget.name ||
        widget.time != oldWidget.time ||
        widget.isMovementAllowed != oldWidget.isMovementAllowed) {
      _timer?.cancel();

      setState(() {
        _remainTime = widget.time?.toInt();
        if (_remainTime != null) {
          startTimer();
          print('[TIMER START]');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        '[TIMER TIME] ${widget.name} ${widget.isMovementAllowed} ${widget.time} TIME : $_remainTime');
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isMovementAllowed == null
              ? Colors.grey
              : (widget.isMovementAllowed! ? Colors.green : Colors.red)),
      child: Stack(
        children: [
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 30,
                ),
                children: [
                  TextSpan(
                    text: '${widget.name} \n',
                  ),
                  TextSpan(
                    text: '${((_remainTime ?? 0) ~/ 10).toInt()}',
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
