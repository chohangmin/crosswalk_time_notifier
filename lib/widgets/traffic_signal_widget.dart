import 'package:flutter/material.dart';

class TrafficSignalWidget extends StatelessWidget {
  const TrafficSignalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: List.generate(signals.length, (index) {
          return Container(width: 50, height: 50, margin: const EdgeInsets.all(8), decoration: BoxDecoration(shape: BoxShape.circle, color: signals[index] ? Colors.blue : Colors.red),)
        }),
      ),
    );
  }
}
