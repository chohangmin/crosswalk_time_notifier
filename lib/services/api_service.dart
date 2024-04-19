import 'dart:convert';

import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:crosswalk_time_notifier/widgets/search_widget.dart';

class ApiService {
  static const String remainTimeUrl =
      'http://t-data.seoul.go.kr/apig/apiman-gateway/tapi/v2xSignalPhaseTimingInformation/1.0';
  static const String signalInfoUrl =
      'http://t-data.seoul.go.kr/apig/apiman-gateway/tapi/v2xSignalPhaseInformation/1.0';

  String apiKey = '';

  late String id; // not yet

  Future<void> initialize() async {
    apiKey = await getApiKey();
    id = await getId();
  }

  Future<String> getApiKey() async {
    await dotenv.load();
    String apiKey = dotenv.env['API_KEY'].toString();
    return apiKey;
  }

  Future<String> getId() async {
    List<Map<String, dynamic>> filteredPosition = await fetchData();
    String id = filteredPosition[0]['id'];
    return id;
  }

  Future<List<RemainTimeModel>> getRemainTimes() async {
    List<RemainTimeModel> remainTimeInstances = [];
    final url = Uri.parse('$remainTimeUrl?apiKey=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final remainTimes = jsonDecode(response.body);
      for (var remainTime in remainTimes) {
        remainTimeInstances.add(RemainTimeModel.fromJson(remainTime));
      }
      return remainTimeInstances;
    }
    throw Error();
  }

  Future<List<SignalInfoModel>> getSignalInfo() async {
    List<SignalInfoModel> signalInfoInstance = [];
    final url = Uri.parse('$signalInfoUrl?apiKey=$apiKey&itstId=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final signalInfos = jsonDecode(response.body);
      for (var signalInfo in signalInfos) {
        signalInfoInstance.add(SignalInfoModel.fromJson(signalInfo));
      }
      return signalInfoInstance;
    }
    throw Error();
  }
}
