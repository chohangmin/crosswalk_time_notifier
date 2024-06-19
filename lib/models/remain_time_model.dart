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

  final DateTime? trsmUtcDateTime;

  RemainTimeModel.fromJson(Map<String, dynamic> json)
      : id = json['itstId'],
        trsmUtcTime = json['trsmUtcTime'],
        trsmUtcDateTime = json['trsmUtcTime'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['trsmUtcTime'].toInt(),
                isUtc: true)
            : null,
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

  DateTime? get trsmLocalTime {
    return trsmUtcDateTime?.toLocal();
  }

  DateTime? get trsmKstTime {
    return trsmUtcDateTime?.add(const Duration(hours: 9));
  }
}
