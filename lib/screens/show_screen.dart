import 'package:crosswalk_time_notifier/test_widgets1/search_nearby_id_widget.dart';
import 'package:crosswalk_time_notifier/test_widgets1/test_search_nearby_id_widget.dart';

import 'package:flutter/material.dart';

class ShowScreen extends StatelessWidget {
  const ShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TestSearchNearbyIdWidget(),
    );
  }
}
