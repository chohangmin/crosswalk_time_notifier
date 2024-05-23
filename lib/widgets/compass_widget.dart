import 'dart:math' as math;

import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';
import 'package:crosswalk_time_notifier/widgets/type2_light_widget.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';

class CompassWidget extends StatefulWidget {
  final List<TrafficInfoModel> signals;
  const CompassWidget({super.key, required this.signals});

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  bool _hasPermissions = false;
  CompassEvent? _lastRead;
  DateTime? _lastReadAt;
  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_hasPermissions) {
          return Column(
            children: <Widget>[
              _buildManualReader(),
              Expanded(
                child: _buildCompass(),
              )
            ],
          );
        } else {
          return _buildPermissionSheet();
        }
      },
    );
  }

  Widget _buildManualReader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          ElevatedButton(
              onPressed: () async {
                final CompassEvent tmp = await FlutterCompass.events!.first;
                setState(() {
                  _lastRead = tmp;
                  _lastReadAt = DateTime.now();
                });
              },
              child: const Text('Read Value')),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('$_lastRead'),
                  Text('$_lastReadAt'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error reading heading: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          double? direction = snapshot.data!.heading;

          if (direction == null) {
            return const Center(
              child: Text('Device does not have sensors'),
            );
          }

          return Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Transform.rotate(
                angle: direction * (math.pi / 180) * -1,
                // child: Type2LightWidget(data: widget.signals),
              ),
            ),
          );
        });
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        children: <Widget>[
          const Text('Location Permission Required'),
          ElevatedButton(
              onPressed: () {
                Permission.locationWhenInUse.request().then((ignored) {
                  _fetchPermissionStatus();
                });
              },
              child: const Text('Request Permissions')),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                openAppSettings().then((open) {});
              },
              child: const Text('Open App Settings')),
        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }
}
