import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';

class LightService {
  late RemainTimeModel filteredRT;
  late SignalInfoModel filteredSI;

  bool ntBcsgStat = false,
      ntPdsgStat = false,
      etBcsgStat = false,
      etPdsgStat = false,
      stBcsgStat = false,
      stPdsgStat = false,
      wtBcsgStat = false,
      wtPdsgStat = false,
      neBcsgStat = false,
      nePdsgStat = false,
      seBcsgStat = false,
      sePdsgStat = false,
      swBcsgStat = false,
      swPdsgStat = false,
      nwBcsgStat = false,
      nwPdsgStat = false;

  void setApiInstances(RemainTimeModel RT, SignalInfoModel SI) {
    filteredRT = RT;
    filteredSI = SI;
  }

  

  bool isNotNull(dynamic field) {
    return field != null;
  }

  void checkNonNullFields() {
    ntBcsgStat = isNotNull(filteredRT.ntBcsgStat);
    ntPdsgStat = isNotNull(filteredRT.ntPdsgStat);
    etBcsgStat = isNotNull(filteredRT.etBcsgStat);
    etPdsgStat = isNotNull(filteredRT.etPdsgStat);
    stBcsgStat = isNotNull(filteredRT.stBcsgStat);
    stPdsgStat = isNotNull(filteredRT.stPdsgStat);
    wtBcsgStat = isNotNull(filteredRT.wtBcsgStat);
    wtPdsgStat = isNotNull(filteredRT.wtPdsgStat);
    neBcsgStat = isNotNull(filteredRT.neBcsgStat);
    nePdsgStat = isNotNull(filteredRT.nePdsgStat);
    seBcsgStat = isNotNull(filteredRT.seBcsgStat);
    sePdsgStat = isNotNull(filteredRT.sePdsgStat);
    swBcsgStat = isNotNull(filteredRT.swBcsgStat);
    swPdsgStat = isNotNull(filteredRT.swPdsgStat);
    nwBcsgStat = isNotNull(filteredRT.nwBcsgStat);
    nwPdsgStat = isNotNull(filteredRT.nwPdsgStat);
  }

  List<bool> getSignalStates() {
    List<bool> signalStates = [
      ntBcsgStat,
      ntPdsgStat,
      etBcsgStat,
      etPdsgStat,
      stBcsgStat,
      stPdsgStat,
      wtBcsgStat,
      wtPdsgStat,
      neBcsgStat,
      nePdsgStat,
      seBcsgStat,
      sePdsgStat,
      swBcsgStat,
      swPdsgStat,
      nwBcsgStat,
      nwPdsgStat,
    ];
    return signalStates;
  }

  bool checkApiInstances() {
    if ((filteredRT.ntBcsgStat != null && filteredSI.ntBcsgStat != null) ||
        (filteredRT.ntPdsgStat != null && filteredSI.ntPdsgStat != null) ||
        (filteredRT.etBcsgStat != null && filteredSI.etBcsgStat != null) ||
        (filteredRT.etPdsgStat != null && filteredSI.etPdsgStat != null) ||
        (filteredRT.stBcsgStat != null && filteredSI.stBcsgStat != null) ||
        (filteredRT.stPdsgStat != null && filteredSI.stPdsgStat != null) ||
        (filteredRT.wtBcsgStat != null && filteredSI.wtBcsgStat != null) ||
        (filteredRT.wtPdsgStat != null && filteredSI.wtPdsgStat != null) ||
        (filteredRT.neBcsgStat != null && filteredSI.neBcsgStat != null) ||
        (filteredRT.nePdsgStat != null && filteredSI.nePdsgStat != null) ||
        (filteredRT.seBcsgStat != null && filteredSI.seBcsgStat != null) ||
        (filteredRT.sePdsgStat != null && filteredSI.sePdsgStat != null) ||
        (filteredRT.swBcsgStat != null && filteredSI.swBcsgStat != null) ||
        (filteredRT.swPdsgStat != null && filteredSI.swPdsgStat != null) ||
        (filteredRT.nwBcsgStat != null && filteredSI.nwBcsgStat != null) ||
        (filteredRT.nwPdsgStat != null && filteredSI.nwPdsgStat != null)) {
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
    print('check ntBcsgStat : $ntBcsgStat\n'
        'check ntPdsgStat : $ntPdsgStat\n'
        'check etBcsgStat : $etBcsgStat\n'
        'check etPdsgStat : $etPdsgStat\n'
        'check stBcsgStat : $stBcsgStat\n'
        'check stPdsgStat : $stPdsgStat\n'
        'check wtBcsgStat : $wtBcsgStat\n'
        'check wtPdsgStat : $wtPdsgStat\n'
        'check neBcsgStat : $neBcsgStat\n'
        'check nePdsgStat : $nePdsgStat\n'
        'check seBcsgStat : $seBcsgStat\n'
        'check sePdsgStat : $sePdsgStat\n'
        'check swBcsgStat : $swBcsgStat\n'
        'check swPdsgStat : $swPdsgStat\n'
        'check nwBcsgStat : $nwBcsgStat\n'
        'check nwPdsgStat : $nwPdsgStat');
  }
}
