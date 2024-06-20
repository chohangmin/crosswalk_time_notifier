import 'dart:async';
import 'dart:math';

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
  final double _angleRad = -11;

  TrafficInfoModel lightValue0 = TrafficInfoModel(
      name: 'Light Value', isMovementAllowed: null, time: null);
  TrafficInfoModel lightValue1 = TrafficInfoModel(
      name: 'Light Value', isMovementAllowed: null, time: null);

  TrafficInfoModel lightValue2 = TrafficInfoModel(
      name: 'Light Value', isMovementAllowed: null, time: null);

  TrafficInfoModel lightValue3 = TrafficInfoModel(
      name: 'Light Value', isMovementAllowed: null, time: null);

  TrafficInfoModel lightValue4 = TrafficInfoModel(
      name: 'Light Value', isMovementAllowed: null, time: null);

  TrafficInfoModel defaultValue =
      TrafficInfoModel(name: 'Default', isMovementAllowed: null, time: null);

  final LocationSettings _locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 0,
    forceLocationManager: true,
    intervalDuration: const Duration(seconds: 1),
    // foregroundNotificationConfig: const ForegroundNotificationConfig(
    //   notificationText:
    //       "Example app will continue to receive your location even when you aren't using it",
    //   notificationTitle: "Running in Background",
    //   enableWakeLock: true,
    // ),
  );

  final double onePR = 0 * pi;
  final double twoPR = 1 / 4 * pi;
  final double threePR = 1 / 2 * pi;
  final double fourPR = 3 / 4 * pi;
  final double fivePR = 1 * pi;

  final double oneNR = -1 * pi;
  final double twoNR = -3 / 4 * pi;
  final double threeNR = -1 / 2 * pi;
  final double fourNR = -1 / 4 * pi;
  final double fiveNR = 0 * pi;

  late double angleRad;
  List<Map<String, dynamic>> results = [];

  int lightDirection = 0;

  late List responses;

  bool isType = true;

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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (lightDirection == 0)
            LightWidget(
              name: lightValue0.name,
              isMovementAllowed: lightValue0.isMovementAllowed,
              time: lightValue0.time,
            ),
          if (lightDirection == 1)
            LightWidget(
              name: lightValue1.name,
              isMovementAllowed: lightValue1.isMovementAllowed,
              time: lightValue1.time,
            ),
          if (lightDirection == 2)
            LightWidget(
              name: lightValue2.name,
              isMovementAllowed: lightValue2.isMovementAllowed,
              time: lightValue2.time,
            ),
          if (lightDirection == 3)
            LightWidget(
              name: lightValue3.name,
              isMovementAllowed: lightValue3.isMovementAllowed,
              time: lightValue3.time,
            ),
          if (lightDirection == 4)
            LightWidget(
              name: lightValue4.name,
              isMovementAllowed: lightValue4.isMovementAllowed,
              time: lightValue4.time,
            ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              _positionStreamStarted = !_positionStreamStarted;
              _toggleListening();
            },
            style: ButtonStyle(
              backgroundColor: _determineButtonColor(),
            ),
            child: (_positionStreamSubscription == null ||
                    _positionStreamSubscription!.isPaused)
                ? const Icon(Icons.play_arrow)
                : const Icon(Icons.pause),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _id = -1;
              });
            },
            child: const Icon(Icons.restore_page_outlined),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                lightDirection = 4;
              });
            },
            child: const Icon(Icons.numbers),
          ),
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
    int i = 0;
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream(
          locationSettings: _locationSettings);
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) async {
        print('[CHECK LISTENING] ${i++}');
        results = [];

        results = await _spatialDbService.findIdsWithinArea(
            position.latitude, position.longitude, 5000);

        // for (var result in results) {
        //   print('[Test] ${result['id']}');
        // }

        if (results.length == 1) {
          int id = results[0]['id'];

          if (_id != id) {
            setState(() {
              _id = id;
            });
            _apiService.setId(id.toString());

            Stopwatch stopwatch = Stopwatch();
            stopwatch.start();
            final Future<RemainTimeModel?> rtFuture =
                _apiService.getRemainTime();

            final Future<SignalInfoModel?> siFuture =
                _apiService.getSignalInfo();

            responses = await Future.wait(
                [siFuture, rtFuture]); // RT api is about 3 seconds faster.
            stopwatch.stop();
            print('{Api Time ${stopwatch.elapsed}}');
            print('[CHECK] api completed');

            if (!checkApiFieldsConsistent(responses)) {
              return;
            }

            isType = checkLightType(responses);

            angleRad = returnAtan2(results[0]['minX'], results[0]['minY'],
                position.latitude, position.longitude);

            if (-0.5 * pi <= angleRad && angleRad < 0.0 * pi) {
              lightDirection = 2;
            } else if (-1 * pi <= angleRad && angleRad < -0.5 * pi) {
              lightDirection = 3;
            } else if (0.5 * pi <= angleRad && angleRad < 1.0 * pi) {
              lightDirection = 4;
            } else {
              lightDirection = 1;
            }

            setState(() {
              if (isType) {
                lightValue1 = TrafficInfoModel(
                    name: 'N',
                    isMovementAllowed: changeSigToBool(responses[0].ntPdsgStat),
                    time: responses[1].ntPdsgStat); // north
                lightValue2 = TrafficInfoModel(
                    name: 'E',
                    isMovementAllowed: changeSigToBool(responses[0].etPdsgStat),
                    time: responses[1].etPdsgStat); // east
                lightValue3 = TrafficInfoModel(
                    name: 'S',
                    isMovementAllowed: changeSigToBool(responses[0].stPdsgStat),
                    time: responses[1].stPdsgStat); // south
                lightValue4 = TrafficInfoModel(
                    name: 'W',
                    isMovementAllowed: changeSigToBool(responses[0].wtPdsgStat),
                    time: responses[1].wtPdsgStat); // west
              } else {
                lightValue1 = TrafficInfoModel(
                    name: 'N E',
                    isMovementAllowed: changeSigToBool(responses[0].nePdsgStat),
                    time: responses[1].nePdsgStat); // north east
                lightValue2 = TrafficInfoModel(
                    name: 'S E',
                    isMovementAllowed: changeSigToBool(responses[0].sePdsgStat),
                    time: responses[1].sePdsgStat); // south east
                lightValue3 = TrafficInfoModel(
                    name: 'S W',
                    isMovementAllowed: changeSigToBool(responses[0].swPdsgStat),
                    time: responses[1].swPdsgStat); // south west
                lightValue4 = TrafficInfoModel(
                    name: 'N W',
                    isMovementAllowed: changeSigToBool(responses[0].nwPdsgStat),
                    time: responses[1].nwPdsgStat); // north west
              }
              print('[CHECK] set test value');
            });
          } else if (_id == id) {
            angleRad = returnAtan2(results[0]['minX'], results[0]['minY'],
                position.latitude, position.longitude);

            if (isType) {
              if (-0.5 * pi <= angleRad && angleRad < 0.0 * pi) {
                lightDirection = 2; // sw
              } else if (-1.0 * pi <= angleRad && angleRad < -0.5 * pi) {
                lightDirection = 3; // se
              } else if (0.5 * pi <= angleRad && angleRad < 1.0 * pi) {
                lightDirection = 4; // nw
              } else if (0.0 * pi <= angleRad && angleRad < 0.5 * pi) {
                lightDirection = 1; // ne
              } else {
                lightDirection = 0;
              }
            } else {
              if ((-1 * pi <= angleRad && angleRad < -0.75 * pi) ||
                  (0.0 * pi <= angleRad && angleRad < 0.25 * pi)) {
                lightDirection = 2; // e
              } else if (0.25 * pi <= angleRad && angleRad < 0.75 * pi) {
                lightDirection = 1; // n
              } else if ((-0.25 * pi <= angleRad && angleRad < 0.0 * pi) ||
                  (0.75 * pi <= angleRad && angleRad < 1.0 * pi)) {
                lightDirection = 4; // w
              } else if (-0.75 * pi <= angleRad && angleRad < -0.25 * pi) {
                lightDirection = 3; // s
              } else {
                lightDirection = 0;
              }
            }

            setState(() {});
          }
        } else {
          setState(() {
            lightValue0 = defaultValue;
            print('[CHECK] default value');
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
        lightValue0 = defaultValue;
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

  double returnAtan2(double lat1, double lon1, double lat2, double lon2) {
    double phi1 = degreesToRadians(lat1);
    double lambda1 = degreesToRadians(lon1);

    double phi2 = degreesToRadians(lat2);
    double lambda2 = degreesToRadians(lon2);

    double x1 = cos(phi1) * cos(lambda1);
    double y1 = cos(phi1) * sin(lambda1);

    double x2 = cos(phi2) * cos(lambda2);
    double y2 = cos(phi2) * sin(lambda2);

    double angleRad = atan2(y2 - y1, x2 - x1);

    return angleRad;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  double radiansToDegrees(double radians) {
    return radians * (180.0 / pi);
  }

  bool checkApiFieldsConsistent(List responses) {
    if ((responses[0].ntPdsgStat != null && responses[1].ntPdsgStat != null) ||
        (responses[0].etPdsgStat != null && responses[1].etPdsgStat != null) ||
        (responses[0].stPdsgStat != null && responses[1].stPdsgStat != null) ||
        (responses[0].wtPdsgStat != null && responses[1].wtPdsgStat != null) ||
        (responses[0].nePdsgStat != null && responses[1].nePdsgStat != null) ||
        (responses[0].sePdsgStat != null && responses[1].sePdsgStat != null) ||
        (responses[0].swPdsgStat != null && responses[1].swPdsgStat != null) ||
        (responses[0].nwPdsgStat != null && responses[1].nwPdsgStat != null)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkLightType(List responses) {
    if ((responses[1].ntPdsgStat != null &&
        responses[1].etPdsgStat != null &&
        responses[1].stPdsgStat != null &&
        responses[1].wtPdsgStat != null)) {
      return true;
    } else {
      return false;
    }
  }
}
