import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  StreamSubscription<Position>? _positionStreamSubscription;

  late final StreamController<Position> _positionStreamController =
      StreamController<Position>.broadcast();

  void startListeningToPositionSream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position != null) {
          _positionStreamController.add(position);
        }
        print(position == null
            ? 'Unknown'
            : 'Listend position : ${position.latitude.toString()}, ${position.longitude.toString()}');
      },
    );
  }

  void stopListeningToPositionStream() {
    _positionStreamSubscription?.cancel();
  }

  Stream<Position> get positionStream => _positionStreamController.stream;

  // Future<Position> determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied.');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are parmanently denied, we cannote request permissions.');
  //   }

  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }
}
