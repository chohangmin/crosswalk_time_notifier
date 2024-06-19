import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';
import 'package:crosswalk_time_notifier/models/traffic_info_model.dart';

class LightService {
  late RemainTimeModel filteredRT;
  late SignalInfoModel filteredSI;

  LightService();

  bool ntPdsgStat = false,
      etPdsgStat = false,
      stPdsgStat = false,
      wtPdsgStat = false,
      nePdsgStat = false,
      sePdsgStat = false,
      swPdsgStat = false,
      nwPdsgStat = false;

  void setApiInstances(RemainTimeModel RT, SignalInfoModel SI) {
    filteredRT = RT;
    filteredSI = SI;
  }

  bool isNotNull(dynamic field) {
    return field != null;
  }

  double getRTUtcTime() {
    return filteredRT.trsmUtcTime!;
  }

  double getSIUtcTime() {
    return filteredSI.trsmUtcTime;
  }

  void checkNonNullFields() {
    ntPdsgStat = isNotNull(filteredRT.ntPdsgStat);

    etPdsgStat = isNotNull(filteredRT.etPdsgStat);

    stPdsgStat = isNotNull(filteredRT.stPdsgStat);

    wtPdsgStat = isNotNull(filteredRT.wtPdsgStat);

    nePdsgStat = isNotNull(filteredRT.nePdsgStat);

    sePdsgStat = isNotNull(filteredRT.sePdsgStat);

    swPdsgStat = isNotNull(filteredRT.swPdsgStat);

    nwPdsgStat = isNotNull(filteredRT.nwPdsgStat);
  }

  List<TrafficInfoModel> getSignalLists() {
    List<TrafficInfoModel> list = [
      TrafficInfoModel(
          name: 'West North P',
          isMovementAllowed: changeSigToBool(filteredSI.nwPdsgStat),
          time: filteredRT.nwPdsgStat),
      TrafficInfoModel(
          name: 'North P',
          isMovementAllowed: changeSigToBool(filteredSI.ntPdsgStat),
          time: filteredRT.ntPdsgStat),
      TrafficInfoModel(
          name: 'North East P',
          isMovementAllowed: changeSigToBool(filteredSI.nePdsgStat),
          time: filteredRT.nePdsgStat),
      TrafficInfoModel(
          name: 'West P',
          isMovementAllowed: changeSigToBool(filteredSI.wtPdsgStat),
          time: filteredRT.wtPdsgStat),
      TrafficInfoModel(
          name: 'East P',
          isMovementAllowed: changeSigToBool(filteredSI.etPdsgStat),
          time: filteredRT.etPdsgStat),
      TrafficInfoModel(
          name: 'South West P',
          isMovementAllowed: changeSigToBool(filteredSI.swPdsgStat),
          time: filteredRT.swPdsgStat),
      TrafficInfoModel(
          name: 'South P',
          isMovementAllowed: changeSigToBool(filteredSI.stPdsgStat),
          time: filteredRT.stPdsgStat),
      TrafficInfoModel(
          name: 'East South P',
          isMovementAllowed: changeSigToBool(filteredSI.sePdsgStat),
          time: filteredRT.sePdsgStat),
    ];

    return list;
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

  List<bool> getSignalStates() {
    List<bool> signalStates = [
      ntPdsgStat,
      etPdsgStat,
      stPdsgStat,
      wtPdsgStat,
      nePdsgStat,
      sePdsgStat,
      swPdsgStat,
      nwPdsgStat,
    ];
    return signalStates;
  }

  bool checkApiFieldsConsistent() {
    if ((filteredRT.ntPdsgStat != null && filteredSI.ntPdsgStat != null) ||
        (filteredRT.etPdsgStat != null && filteredSI.etPdsgStat != null) ||
        (filteredRT.stPdsgStat != null && filteredSI.stPdsgStat != null) ||
        (filteredRT.wtPdsgStat != null && filteredSI.wtPdsgStat != null) ||
        (filteredRT.nePdsgStat != null && filteredSI.nePdsgStat != null) ||
        (filteredRT.sePdsgStat != null && filteredSI.sePdsgStat != null) ||
        (filteredRT.swPdsgStat != null && filteredSI.swPdsgStat != null) ||
        (filteredRT.nwPdsgStat != null && filteredSI.nwPdsgStat != null)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkLightType() {
    if ((filteredRT.ntPdsgStat != null &&
        filteredRT.etPdsgStat != null &&
        filteredRT.stPdsgStat != null &&
        filteredRT.wtPdsgStat != null)) {
      return true;
    } else {
      return false;
    }
  }

  void printApiInstances() {
    print('[FIND] filteredRT $filteredRT');
    print('[FIND] filteredRT $filteredSI');
  }

  void printStats() {
    print('check ntPdsgStat : $ntPdsgStat\n'
        'check etPdsgStat : $etPdsgStat\n'
        'check stPdsgStat : $stPdsgStat\n'
        'check wtPdsgStat : $wtPdsgStat\n'
        'check nePdsgStat : $nePdsgStat\n'
        'check sePdsgStat : $sePdsgStat\n'
        'check swPdsgStat : $swPdsgStat\n'
        'check nwPdsgStat : $nwPdsgStat');
  }
}
