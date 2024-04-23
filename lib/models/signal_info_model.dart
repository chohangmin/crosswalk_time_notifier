class SignalInfoModel {
  final String? id,
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
      nwPdsgStat;

  SignalInfoModel.fromJson(Map<String, dynamic> json)
      : id = json['itstId'],
        ntBcsgStat = json['ntBcsgStatNm'],
        ntPdsgStat = json['ntPdsgStatNm'],
        etBcsgStat = json['etBcsgStatNm'],
        etPdsgStat = json['etPdsgStatNm'],
        stBcsgStat = json['stBcsgStatNm'],
        stPdsgStat = json['stPdsgStatNm'],
        wtBcsgStat = json['wtBcsgStatNm'],
        wtPdsgStat = json['wtPdsgStatNm'],
        neBcsgStat = json['neBcsgStatNm'],
        nePdsgStat = json['nePdsgStatNm'],
        seBcsgStat = json['seBcsgStatNm'],
        sePdsgStat = json['sePdsgStatNm'],
        swBcsgStat = json['swBcsgStatNm'],
        swPdsgStat = json['swPdsgStatNm'],
        nwBcsgStat = json['nwBcsgStatNm'],
        nwPdsgStat = json['nwPdsgStatNm'];

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
