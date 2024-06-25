import 'dart:convert';

import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CrossInfoApiService {

  static const String remainTimeUrl =
      'http://t-data.seoul.go.kr/apig/apiman-gateway/tapi/v2xSignalPhaseTimingInformation/1.0';
  static const String signalInfoUrl =
      'http://t-data.seoul.go.kr/apig/apiman-gateway/tapi/v2xSignalPhaseInformation/1.0';

  late String apiKey;
  late String id;

  Future<void> setApiKey() async {
    await dotenv.load();
    apiKey = await getApiKey(); // Set api key
  }

  Future<String> getApiKey() async {
    String apiKey = dotenv.env['API_KEY'].toString();
    return apiKey; // Get api key from env
  }

  void setId(String newId) {
    id = newId;
  }

  Future<RemainTimeModel?> getRemainTime() async {
    RemainTimeModel? remainTimeInstance;
    final url = Uri.parse('$remainTimeUrl?apiKey=$apiKey&itstId=$id');

  
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final remainTimes = jsonDecode(response.body);

      print('{Remain Time Api called}');
      remainTimeInstance = RemainTimeModel.fromJson(remainTimes[0]);
      print('<RT Value> ${remainTimeInstance.trsmKstTime?.toLocal()}');

      return remainTimeInstance;
    } else {
      throw Exception(
          'Failed to fetch signal info. Status code: ${response.statusCode}');
    }
  }

  Future<SignalInfoModel?> getSignalInfo() async {
    SignalInfoModel? signalInfoInstance;
    final url = Uri.parse('$signalInfoUrl?apiKey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final signalInfos = jsonDecode(response.body);
      print('{Signal Info Api called}');
      for (var signalInfo in signalInfos) {
        var instance = SignalInfoModel.fromJson(signalInfo);
        if (instance.id == id) {
          signalInfoInstance = instance;
          print('<SI Value> ${signalInfoInstance.trsmKstTime?.toLocal()}');
          return signalInfoInstance;
        }
      }
    } else {
      throw Exception(
          'Failed to fetch signal info. Status code: ${response.statusCode}');
    }
    return null;
  }
}
