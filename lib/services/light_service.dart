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

  void setApiInstances(RemainTimeModel filteredRT, SignalInfoModel filteredSI) {
    filteredRT = filteredRT;
    filteredSI = filteredSI;
  }

  void checkApiInstances() {
    if (_checkNullFieldsSI(filteredSI) && _checkNullFieldsRT(filteredRT)) {}
  }

  bool _checkNullFieldsSI(SignalInfoModel model) {
    return model.id != null &&
        model.ntBcsgStat != null &&
        model.ntPdsgStat != null &&
        model.etBcsgStat != null &&
        model.etPdsgStat != null &&
        model.stBcsgStat != null &&
        model.stPdsgStat != null &&
        model.wtBcsgStat != null &&
        model.wtPdsgStat != null &&
        model.neBcsgStat != null &&
        model.nePdsgStat != null &&
        model.seBcsgStat != null &&
        model.sePdsgStat != null &&
        model.swBcsgStat != null &&
        model.swPdsgStat != null &&
        model.nwBcsgStat != null &&
        model.nwPdsgStat != null;
  }

  bool _checkNullFieldsRT(RemainTimeModel model) {
    return model.id != null &&
        model.trsmYear != null &&
        model.trsmMt != null &&
        model.trsmTm != null &&
        model.trsmMs != null &&
        model.ntBcsgStat != null &&
        model.ntPdsgStat != null &&
        model.etBcsgStat != null &&
        model.etPdsgStat != null &&
        model.stBcsgStat != null &&
        model.stPdsgStat != null &&
        model.wtBcsgStat != null &&
        model.wtPdsgStat != null &&
        model.neBcsgStat != null &&
        model.nePdsgStat != null &&
        model.seBcsgStat != null &&
        model.sePdsgStat != null &&
        model.swBcsgStat != null &&
        model.swPdsgStat != null &&
        model.nwBcsgStat != null &&
        model.nwPdsgStat != null;
  }
}
