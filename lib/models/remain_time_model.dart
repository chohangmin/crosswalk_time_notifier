class RemainTimeModel {
  final String? id, trsmYear, trsmMt, trsmTm, trsmMs;

  final double? trsmUtcTime,

      ntPdsgStat,

      etPdsgStat,

      stPdsgStat,

      wtPdsgStat,

      nePdsgStat,

      sePdsgStat,

      swPdsgStat,

      nwPdsgStat;

  RemainTimeModel.fromJson(Map<String, dynamic> json)
      : id = json['itstId'],
        trsmUtcTime = json['trsmUtcTime'],
        trsmYear = json['trsmYear'],
        trsmMt = json['trsmMt'],
        trsmTm = json['trsmTm'],
        trsmMs = json['trsmMs'],

        ntPdsgStat = json['ntPdsgRmdrCs'],

        etPdsgStat = json['etPdsgRmdrCs'],

        stPdsgStat = json['stPdsgRmdrCs'],

        wtPdsgStat = json['wtPdsgRmdrCs'],

        nePdsgStat = json['nePdsgRmdrCs'],

        sePdsgStat = json['sePdsgRmdrCs'],

        swPdsgStat = json['swPdsgRmdrCs'],

        nwPdsgStat = json['nwPdsgRmdrCs'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trsmUtcTime': trsmUtcTime,

      'ntPdsgStat': ntPdsgStat,

      'etPdsgStat': etPdsgStat,

      'stPdsgStat': stPdsgStat,

      'wtPdsgStat': wtPdsgStat,

      'nePdsgStat': nePdsgStat,

      'sePdsgStat': sePdsgStat,

      'swPdsgStat': swPdsgStat,

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

        '  ntPdsgStat: $ntPdsgStat,\n'

        '  etPdsgStat: $etPdsgStat,\n'

        '  stPdsgStat: $stPdsgStat,\n'

        '  wtPdsgStat: $wtPdsgStat,\n'

        '  nePdsgStat: $nePdsgStat,\n'

        '  sePdsgStat: $sePdsgStat,\n'

        '  swPdsgStat: $swPdsgStat,\n'

        '  nwPdsgStat: $nwPdsgStat\n'
        '}';
  }
}
