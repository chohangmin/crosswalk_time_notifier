import 'dart:math';

class SearchService {
  // 검색 결과를 필터링하는 함수
  List<Map<String, dynamic>> filterCoordinates(
      List<Map<String, dynamic>> coordinates,
      double radius,
      double userLatitude,
      double userLongitude) {
    List<Map<String, dynamic>> filteredCoordinates = [];
    // 결과 필터링: 실제로 사용자에게 보여줄 범위 내의 좌표만을 필터링
    for (var coordinate in coordinates) {
      // 좌표와 사용자의 현재 위치 간의 거리 계산
      double distance = calculateDistance(
        coordinate['lat'],
        coordinate['lon'],
        userLatitude,
        userLongitude,
      );
      // 일정 반경 내에 있는 좌표만을 추가
      if (distance <= radius) {
        filteredCoordinates.add(coordinate);
      }
    }
    return filteredCoordinates;
  }

// 두 지점 간의 거리를 계산하는 함수 (Haversine formula 사용)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // 지구 반지름 (단위: km)
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
