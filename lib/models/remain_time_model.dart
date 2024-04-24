class RemainTimeModel {
  final String? id, trsmYear, trsmMt, trsmTm, trsmMs;

  final double? ntBcsgStat,
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
      nwPdsgStat;

  RemainTimeModel.fromJson(Map<String, dynamic> json)
      : id = json['itstId'],
        trsmYear = json['trsmYear'],
        trsmMt = json['trsmMt'],
        trsmTm = json['trsmTm'],
        trsmMs = json['trsmMs'],
        ntBcsgStat = json['ntBcsgRmdrCs'],
        ntPdsgStat = json['ntPdsgRmdrCs'],
        etBcsgStat = json['etBcsgRmdrCs'],
        etPdsgStat = json['etPdsgRmdrCs'],
        stBcsgStat = json['stBcsgRmdrCs'],
        stPdsgStat = json['stPdsgRmdrCs'],
        wtBcsgStat = json['wtBcsgRmdrCs'],
        wtPdsgStat = json['wtPdsgRmdrCs'],
        neBcsgStat = json['neBcsgRmdrCs'],
        nePdsgStat = json['nePdsgRmdrCs'],
        seBcsgStat = json['seBcsgRmdrCs'],
        sePdsgStat = json['sePdsgRmdrCs'],
        swBcsgStat = json['swBcsgRmdrCs'],
        swPdsgStat = json['swPdsgRmdrCs'],
        nwBcsgStat = json['nwBcsgRmdrCs'],
        nwPdsgStat = json['nwPdsgRmdrCs'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ntBcsgStat': ntBcsgStat,
      'ntPdsgStat': ntPdsgStat,
      'etBcsgStat': etBcsgStat,
      'etPdsgStat': etPdsgStat,
      'stBcsgStat': stBcsgStat,
      'stPdsgStat': stPdsgStat,
      'wtBcsgStat': wtBcsgStat,
      'wtPdsgStat': wtPdsgStat,
      'neBcsgStat': neBcsgStat,
      'nePdsgStat': nePdsgStat,
      'seBcsgStat': seBcsgStat,
      'sePdsgStat': sePdsgStat,
      'swBcsgStat': swBcsgStat,
      'swPdsgStat': swPdsgStat,
      'nwBcsgStat': nwBcsgStat,
      'nwPdsgStat': nwPdsgStat,
    };
  }

  @override
  String toString() {
    return 'SignalInfoModel{\n'
        '  id: $id,\n'
        '  trsmYear: $trsmYear,\n'
        '  trsmMt: $trsmMt,\n'
        '  trsmTm: $trsmTm,\n'
        '  trsmMs: $trsmMs,\n'
        '  ntBcsgStat: $ntBcsgStat,\n'
        '  ntPdsgStat: $ntPdsgStat,\n'
        '  etBcsgStat: $etBcsgStat,\n'
        '  etPdsgStat: $etPdsgStat,\n'
        '  stBcsgStat: $stBcsgStat,\n'
        '  stPdsgStat: $stPdsgStat,\n'
        '  wtBcsgStat: $wtBcsgStat,\n'
        '  wtPdsgStat: $wtPdsgStat,\n'
        '  neBcsgStat: $neBcsgStat,\n'
        '  nePdsgStat: $nePdsgStat,\n'
        '  seBcsgStat: $seBcsgStat,\n'
        '  sePdsgStat: $sePdsgStat,\n'
        '  swBcsgStat: $swBcsgStat,\n'
        '  swPdsgStat: $swPdsgStat,\n'
        '  nwBcsgStat: $nwBcsgStat,\n'
        '  nwPdsgStat: $nwPdsgStat\n'
        '}';
  }


}
