import 'package:crosswalk_time_notifier/services/light_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LightWidget extends StatelessWidget {
  final List<bool> signals;

  const LightWidget({required this.signals, super.key});

  @override
  Widget build(BuildContext context) {
    print('Signals: $signals');
    return Scaffold(
        body: ListView.builder(
            itemCount: signals.length,
            itemBuilder: (context, index) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: signals[index] ? Colors.blue : Colors.red,
                ),
              );
            }));
  }
}
