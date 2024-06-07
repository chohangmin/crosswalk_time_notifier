import 'package:crosswalk_time_notifier/widgets/light_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ElevatedButton(onPressed: onPressed, child: child),
          ElevatedButton(onPressed: onPressed, child: child),
         LightWidget(),
        ],
      ),
    );
  }
}
