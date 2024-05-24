
import 'package:crosswalk_time_notifier/widgets/search_nearby_id_widget.dart';

import 'package:flutter/material.dart';

class ShowScreen extends StatelessWidget {
  const ShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SearchNearbyIdWidget(),
    );
  }
}
