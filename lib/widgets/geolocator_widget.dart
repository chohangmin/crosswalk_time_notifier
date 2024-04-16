import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/services/geolocator_service.dart';

class GeolocatorWidget extends StatefulWidget {
  const GeolocatorWidget({Key? key}) : super(key: key);

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  final GeolocatorService _geolocatorService = GeolocatorService();

  @override
  void initState() {
    super.initState();
    _geolocatorService.toggleServiceStatusStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocator Widget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _geolocatorService.getCurrentPosition();
              },
              child: Text('Get Current Position'),
            ),
            ElevatedButton(
              onPressed: () {
                _geolocatorService.toggleListening();
              },
              child: Text('Toggle Listening'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _geolocatorService.dispose();
    super.dispose();
  }
}
