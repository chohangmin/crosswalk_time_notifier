class SignalInfoModel {
  final double trsmUtcTime;
  final String? id,
      ntPdsgStat,
      etPdsgStat,
      stPdsgStat,
      wtPdsgStat,
      nePdsgStat,
      sePdsgStat,
      swPdsgStat,
      nwPdsgStat;

  final DateTime? trsmUtcDateTime;

  SignalInfoModel.fromJson(Map<String, dynamic> json)
      : id = json['itstId'],
        trsmUtcTime = json['trsmUtcTime'],
        trsmUtcDateTime = json['trsmUtcTime'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['trsmUtcTime'].toInt(),
                    isUtc: true)
                .add(const Duration(hours: 9))
            : null,
        ntPdsgStat = json['ntPdsgStatNm'],
        etPdsgStat = json['etPdsgStatNm'],
        stPdsgStat = json['stPdsgStatNm'],
        wtPdsgStat = json['wtPdsgStatNm'],
        nePdsgStat = json['nePdsgStatNm'],
        sePdsgStat = json['sePdsgStatNm'],
        swPdsgStat = json['swPdsgStatNm'],
        nwPdsgStat = json['nwPdsgStatNm'];

  DateTime? get trsmLocalTime {
    return trsmUtcDateTime?.toLocal();
  }

  DateTime? get trsmKstTime {
    return trsmUtcDateTime?.add(const Duration(hours: 9));
  }
}
