import 'dart:async';

import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';
import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';
import 'package:crosswalk_time_notifier/services/api_service.dart';
import 'package:crosswalk_time_notifier/widgets/light_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crosswalk_time_notifier/services/spatial_db_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final SpatialDbService _spatialDbService = SpatialDbService();
  final ApiService _apiService = ApiService();
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool _positionStreamStarted = false;
  int _id = -1;
  TrafficInfoModel lightValue = TrafficInfoModel(
      name: 'Light Value', isMovementAllowed: null, time: null);

  TrafficInfoModel defaultValue =
      TrafficInfoModel(name: 'Default', isMovementAllowed: null, time: null);

  @override
  void initState() {
    super.initState();
    _toggleServiceStatusStream();
    _apiService.setApiKey();
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _positionStreamStarted = !_positionStreamStarted;
              _toggleListening();
              setState(() {});
            },
            style: ButtonStyle(
              backgroundColor: _determineButtonColor(),
            ),
            child: (_positionStreamSubscription == null ||
                    _positionStreamSubscription!.isPaused)
                ? const Icon(Icons.play_arrow)
                : const Icon(Icons.pause),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _id = -1;
                });
              },
              child: const Icon(Icons.ac_unit)),
          LightWidget(
            name: lightValue.name,
            isMovementAllowed: lightValue.isMovementAllowed,
            time: lightValue.time,
          )
        ],
      ),
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  WidgetStateProperty<Color?> _determineButtonColor() {
    return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      return _isListening() ? Colors.green : Colors.red;
    });
  }

  void _toggleServiceStatusStream() async {
    bool permission;
    permission = await _handlePermission();

    if (!permission) {
      print('Error not permission');
      return;
    }

    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        if (serviceStatus == ServiceStatus.enabled) {
          if (_positionStreamStarted) {
            _toggleListening();
          }
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
            });
          }
        }
      });
    }
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) async {
        List<Map<String, dynamic>> results = [];

        results = await _spatialDbService.findIdsWithinArea(
            position.latitude, position.longitude, 5000);

        // for (var result in results) {
        //   print('[Test] ${result['id']}');
        // }

        if (results.length == 1) {
          int id = results[0]['id'];

          if (_id != id) {
            _apiService.setId(id.toString());

            final Future<RemainTimeModel?> rtFuture =
                _apiService.getRemainTime();
            final Future<SignalInfoModel?> siFuture =
                _apiService.getSignalInfo();

            final List responses = await Future.wait([siFuture, rtFuture]);

            TrafficInfoModel testValue = TrafficInfoModel(
                name: 'Test S E',
                isMovementAllowed: changeSigToBool(responses[0].sePdsgStat),
                time: responses[1].sePdsgStat);

            print('[BOOL] ${responses[0].sePdsgStat}');
            print('[TIME] ${responses[1].sePdsgStat}');

            setState(() {
              _id = id;
              lightValue = testValue;
            });
          }
        } else {
          setState(() {
            lightValue = defaultValue;
          });
        }
      });
      _positionStreamSubscription?.pause();
    }
    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
      } else {
        _positionStreamSubscription!.pause();
      }
    });
  }

  bool? changeSigToBool(String? SigState) {
    if (SigState == 'protected-Movement-Allowed' ||
        SigState == 'permissive-Movement-Allowed') {
      return true;
    } else if (SigState == 'stop-And-Remain') {
      return false;
    }

    return null;
  }
}
