import 'dart:async';

import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GeolocatorService _geolocatorService = GeolocatorService();

  @override
  void initState() {
    super.initState();
    _geolocatorService.startListeningToPositionSream();

  }

  @override
  void dispose() {
    _geolocatorService.stopListeningToPositionStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ,
    );
  }
}
