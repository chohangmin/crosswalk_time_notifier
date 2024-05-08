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

  SignalInfoModel.fromJson(Map<String, dynamic> json)
      : id = json['itstId'],
        trsmUtcTime = json['trsmUtcTime'],

        ntPdsgStat = json['ntPdsgStatNm'],

        etPdsgStat = json['etPdsgStatNm'],

        stPdsgStat = json['stPdsgStatNm'],

        wtPdsgStat = json['wtPdsgStatNm'],

        nePdsgStat = json['nePdsgStatNm'],

        sePdsgStat = json['sePdsgStatNm'],

        swPdsgStat = json['swPdsgStatNm'],
        nwPdsgStat = json['nwPdsgStatNm'];

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
