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
    // _remainTime = widget.time?.toInt();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      
        if (_remainTime! <= 0) {
            _timer.cancel();
          
          widget.isMovementAllowed = !widget.isMovementAllowed!;
          _remainTime = 0;
          setState(() {
            
          });
        } else {
           _remainTime = _remainTime! - 10;
           setState(() {
             
           });
        }

    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(LightWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    //     if (widget.time != oldWidget.time || widget.isMovementAllowed != oldWidget.isMovementAllowed) {
    //   resetTimer();
    // }

    print('[WIDGET UPDATE]');
    if (widget.name == 'Default') {
      dispose();
    }

    setState(() {
      _remainTime = widget.time?.toInt();
      if (_remainTime != null) {
        startTimer();
        print('[TIMER START]');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        '[TIMER TIME] ${widget.name} ${widget.isMovementAllowed} ${widget.time} TIME : $_remainTime');
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
