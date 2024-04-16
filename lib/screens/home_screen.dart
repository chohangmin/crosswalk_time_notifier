import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/services/geolocator_service.dart';
import 'package:crosswalk_time_notifier/widgets/geolocator_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GeolocatorService geolocatorService = GeolocatorService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen'),),
      body: GeolocatorWidget(),
    );
  }
}
