class CrossMapModel {
  final int id;
  final String name;
  final double mapLat, mapLon;

  CrossMapModel.fromJson(Map<String, dynamic> json)
      : id = json['itstId'],
        name = json['itstNm'],
        mapLat = json['mapCtptIntLat'],
        mapLon = json['mapCtptIntLot'];
}
