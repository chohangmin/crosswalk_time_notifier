import 'package:crosswalk_time_notifier/services/light_service.dart';
import 'package:flutter/material.dart';

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
                width: 10,
                height: 10,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: signals[index] ? Colors.blue : Colors.red,
                ),
              );
            })

        // Column(
        //   children: List.generate(signals.length, (index) {
        //     return Container(
        //       width: 50,
        //       height: 50,
        //       margin: const EdgeInsets.all(8),
        //       decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: signals[index] ? Colors.blue : Colors.red),
        //     );
        //   }),
        // ),
        );
  }
}
