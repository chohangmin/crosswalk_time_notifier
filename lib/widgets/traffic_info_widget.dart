import 'package:flutter/material.dart';

class TrafficInfo extends StatelessWidget {
  final String name;
  final bool isMovementAllowed;
  final double time;

  const TrafficInfo({
    super.key,
    required this.name,
    required this.isMovementAllowed,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isMovementAllowed ? Colors.blue : Colors.red,
      ),
      child: Stack(
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                text: '$time',
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