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


}
