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

  TrafficInfoModel lightValue0 = TrafficInfoModel(
      name: 'Light Value 0', isMovementAllowed: null, time: null);
  TrafficInfoModel lightValue1 = TrafficInfoModel(
      name: 'Light Value 1', isMovementAllowed: null, time: null);

  TrafficInfoModel lightValue2 = TrafficInfoModel(
      name: 'Light Value 2', isMovementAllowed: null, time: null);

  TrafficInfoModel lightValue3 = TrafficInfoModel(
      name: 'Light Value 3', isMovementAllowed: null, time: null);

  TrafficInfoModel lightValue4 = TrafficInfoModel(
      name: 'Light Value 4', isMovementAllowed: null, time: null);

  TrafficInfoModel defaultValue =
      TrafficInfoModel(name: 'Default', isMovementAllowed: null, time: null);

  final LocationSettings _locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 0,
    forceLocationManager: true,
    intervalDuration: const Duration(seconds: 1),
  );

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
          Stack(
            children: [
              Opacity(
                opacity: lightDirection == 0 ? 1.0 : 0.0,
                child: LightWidget(
                  name: lightValue0.name,
                  isMovementAllowed: lightValue0.isMovementAllowed,
                  time: lightValue0.time,
                ),
              ),
              Opacity(
                opacity: lightDirection == 1 ? 1.0 : 0.0,
                child: LightWidget(
                  name: lightValue1.name,
                  isMovementAllowed: lightValue1.isMovementAllowed,
                  time: lightValue1.time,
                ),
              ),
              Opacity(
                opacity: lightDirection == 2 ? 1.0 : 0.0,
                child: LightWidget(
                  name: lightValue2.name,
                  isMovementAllowed: lightValue2.isMovementAllowed,
                  time: lightValue2.time,
                ),
              ),
              Opacity(
                opacity: lightDirection == 3 ? 1.0 : 0.0,
                child: LightWidget(
                  name: lightValue3.name,
                  isMovementAllowed: lightValue3.isMovementAllowed,
                  time: lightValue3.time,
                ),
              ),
              Opacity(
                opacity: lightDirection == 4 ? 1.0 : 0.0,
                child: LightWidget(
                  name: lightValue4.name,
                  isMovementAllowed: lightValue4.isMovementAllowed,
                  time: lightValue4.time,
                ),
              ),
            ],
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
                lightDirection = 0;
              });
            },
            child: const Icon(Icons.exposure_zero),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                lightDirection = 1;
              });
            },
            child: const Icon(Icons.looks_one),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                lightDirection = 2;
              });
            },
            child: const Icon(Icons.looks_two),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                lightDirection = 3;
              });
            },
            child: const Icon(Icons.looks_3),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                lightDirection = 4;
              });
            },
            child: const Icon(Icons.looks_4),
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
            position.longitude, position.latitude, 5000);

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

            double angleDeg = angleRad * (180 / pi);

            if (angleDeg < 0) {
              angleDeg += 360;
            }

            setState(() {
              if (isType) {
                if (angleDeg >= 0 && angleDeg < 45 ||
                    angleDeg >= 315 && angleDeg < 360) {
                  lightDirection = 2; // 동쪽 (E)
                } else if (angleDeg >= 225 && angleDeg < 315) {
                  lightDirection = 3; // 남쪽 (S)
                } else if (angleDeg >= 135 && angleDeg < 225) {
                  lightDirection = 4; // 서쪽 (W)
                } else {
                  lightDirection = 1; // 북쪽 (N)
                }

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
                if (angleDeg >= 0 && angleDeg < 90) {
                  lightDirection = 1; // 북동쪽 (NE)
                } else if (angleDeg >= 270 && angleDeg < 360) {
                  lightDirection = 3; // 남동쪽 (SE)
                } else if (angleDeg >= 180 && angleDeg < 270) {
                  lightDirection = 2; // 남서쪽 (SW)
                } else {
                  lightDirection = 4; // 북서쪽 (NW)
                }

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
            
            });
          } else if (_id == id) {
            angleRad = returnAtan2(results[0]['minX'], results[0]['minY'],
                position.latitude, position.longitude);

            double angleDeg = angleRad * (180 / pi);

            if (isType) {
              if (angleDeg >= 0 && angleDeg < 45 ||
                  angleDeg >= 315 && angleDeg < 360) {
                lightDirection = 2; // 동쪽 (E)
              } else if (angleDeg >= 225 && angleDeg < 315) {
                lightDirection = 3; // 남쪽 (S)
              } else if (angleDeg >= 135 && angleDeg < 225) {
                lightDirection = 4; // 서쪽 (W)
              } else {
                lightDirection = 1; // 북쪽 (N)
              }
            } else {
              if (angleDeg >= 0 && angleDeg < 90) {
                lightDirection = 1; // 북동쪽 (NE)
              } else if (angleDeg >= 270 && angleDeg < 360) {
                lightDirection = 3; // 남동쪽 (SE)
              } else if (angleDeg >= 180 && angleDeg < 270) {
                lightDirection = 2; // 남서쪽 (SW)
              } else {
                lightDirection = 4; // 북서쪽 (NW)
              }
            }

            setState(() {});
          }
        } else {
          setState(() {
            lightValue0 = defaultValue;
            lightValue1 = defaultValue;
            lightValue2 = defaultValue;
            lightValue3 = defaultValue;
            lightValue4 = defaultValue;
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
