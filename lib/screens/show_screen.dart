import 'package:crosswalk_time_notifier/test_widgets/search_widget.dart';
import 'package:crosswalk_time_notifier/widgets/search_nearby_id_widget.dart';
import 'package:crosswalk_time_notifier/test_widgets/traffic_signal_widget.dart';
import 'package:flutter/material.dart';

class ShowScreen extends StatelessWidget {
  const ShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // body: const TrafficSignalWidget(),
      // body: SearchWidget(),
      body: SearchNearbyIdWidget(),
    );
  }
}
