import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crosswalk_time_notifier/models/cross_map_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DbApiService {
  static const String crossMapUrl =
      'http://t-data.seoul.go.kr/apig/apiman-gateway/tapi/v2xCrossroadMapInformation/1.0';

  late String apiKey;

  Future<void> setApiKey() async {
    await dotenv.load();
    apiKey = await getApiKey();
  }

  Future<String> getApiKey() async {
    String apiKey = dotenv.env['API_KEY'].toString();
    return apiKey;
  }

  Future<List<CrossMapModel>> getCrossMap() async {
    List<CrossMapModel> crossMapInstances = [];
    final url = Uri.parse('$crossMapUrl?apiKey=$apiKey');
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final crossMaps = jsonDecode(response.body);

      for (var crossMap in crossMaps) {
        var crossMapInstance = CrossMapModel.fromJson(crossMap);
        crossMapInstances.add(crossMapInstance);
      }

      return crossMapInstances;
    } else {
      throw Exception(
          'Failed to fetch cross Map. Status code: ${response.statusCode}');
    }
  }
}
