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


}
