import 'package:flutter/material.dart';
import 'dart:async';

class TrafficInfo extends StatefulWidget {
  final String name;
  bool? isMovementAllowed;
  double? time;

  TrafficInfo({
    super.key,
    required this.name,
    required this.isMovementAllowed,
    required this.time,
  });

  @override
  State<TrafficInfo> createState() => _TrafficInfoState();
}

class _TrafficInfoState extends State<TrafficInfo> {
  late Timer _timer;
  int? _remainingTime;
  @override
  void initState() {
    super.initState();
    _remainingTime = widget.time?.toInt();
    if (_remainingTime != null) {
      startTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime! > 0) {
          _remainingTime = _remainingTime! - 20;
        } else {
          timer.cancel();
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
    print('[${widget.name}] ${widget.isMovementAllowed} $_remainingTime');
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.isMovementAllowed == null
            ? Colors.black
            : (widget.isMovementAllowed! ? Colors.blue : Colors.red),
      ),
      child: Stack(
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                text:
                    '${widget.name} \n ${((_remainingTime ?? 0) ~/ 10).toInt()}',
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


// enum SignalState {
//   stopAndRemain,
//   protectedMovementAllowed,
//   permissiveMovementAllowed,
// }

// extension SignalStateExtension on SignalState {
//   Color get color {
//     switch (this) {
//       case SignalState.stopAndRemain:
//         return Colors.red;
//       case SignalState.protectedMovementAllowed:
//         return Colors.green;
//       case SignalState.permissiveMovementAllowed:
//         return Colors.yellow;
//       default:
//         return Colors.black;
//     }
//   }
// }