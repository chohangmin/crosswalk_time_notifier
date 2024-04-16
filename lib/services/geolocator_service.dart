import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  static const String kLocationServicesDisableMessage =
      'Location services are disabled.';
  static const String kPermissionDeniedMessage = 'Permission denied.';
  static const String kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  final List<PositionItem> positionItems = <PositionItem>[];
  StreamSubscription<Position>? positionStreamSubscription;
  StreamSubscription<ServiceStatus>? serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  @override
  void initState() {
    super.initState();
    toggleServiceStatusStream();
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = geolocatorPlatform.getCurrentPosition();

    updatePositionList(
      PositionItemType.position,
      position.toString(),
    );
  }

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      updatePositionList(
        PositionItemType.log,
        kLocationServicesDisableMessage,
      );

      return false;
    }

    permission = await geolocatorPlatform.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        updatePositionList(
          PositionItemType.log,
          kPermissionDeniedMessage,
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      updatePositionList(
        PositionItemType.log,
        kPermissionDeniedForeverMessage,
      );

      return false;
    }

    updatePositionList(
      PositionItemType.log,
      kPermissionGrantedMessage,
    );

    return true;
  }

  void updatePositionList(PositionItemType type, String displayValue) {
    positionItems.add(PositionItem(type, displayValue));
    setstate(() {});
  }

  void toggleServiceStatusStream() {
    if (serviceStatusStreamSubscription == null) {
      final serviceStatusStream = geolocatorPlatform.getServiceStatusStream();
      serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        serviceStatusStreamSubscription?.cancel();
        serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            toggleListening();
          }
          serviceStatusValue = 'enabled';
        } else {
          if (positionStreamSubscription != null) {
            setState(() {
              positionStreamSubscription?.cancel();
              positionStreamSubscription = null;
              updatePositionList(
                  PositionItemType.log, 'Position Stream has been canceled.');
            });
          }
          serviceStatusValue = 'disabled';
        }
        updatePositionList(
          PositionItemType.log,
          'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  void toggleListening() {
    if (positionStreamSubscription == null) {
      final positionStream = geolocatorPlatform.getPositionStream();
      positionStreamSubscription = positionStream.handleError((error) {
        positionStreamSubscription?.cancel();
        positionStreamSubscription = null;
      }).listen((position) => updatePositionList(
            PositionItemType.position,
            position.toString(),
          ));
      positionStreamSubscription?.pause();
    }

    setState(() {
      if (positionStreamSubscription == null) {
        return;
      }
      String statusDisplayValue;
      if (positionStreamSubscription!.isPaused) {
        positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        positionStreamSubscription!.pause();
        statusDisplayValue = 'pause';
      }

      updatePositionList(
        PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  @override
  void dispose() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
      positionStreamSubscription = null;
    }

    super.dispose();
  }
}

enum PositionItemType {
  log,
  position,
}

class PositionItem {
  PositionItem(this.type, this.displayValue);

  final PositionItemType type;
  final String displayValue;
}
