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

  late String apiKey;

  late String id; // not yet

  Future<void> initialize() async {
    await dotenv.load();
    apiKey = await getApiKey();
  }

  Future<String> getApiKey() async {
    String apiKey = dotenv.env['API_KEY'].toString();
    return apiKey;
  }

  void setId(String newId) {
    id = newId;
    print('ID has been set to: $id');
  }

//List<RemainTimeModel>
  Future<void> getRemainTimes() async {
    List<RemainTimeModel> remainTimeInstances = [];
    print('check 123');
    print('check the orders $apiKey');
    final url = Uri.parse('$remainTimeUrl?apiKey=$apiKey');
    print('$remainTimeUrl?apiKey=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final remainTimes = jsonDecode(response.body);
      print('before duration.');
      for (var remainTime in remainTimes) {
        print('1');
        remainTimeInstances.add(RemainTimeModel.fromJson(remainTime));
        print('2');
      }
      print('Remain Time : $remainTimeInstances');
      // return remainTimeInstances;
    } else {
      throw Exception(
          'Failed to fetch signal info. Status code: ${response.statusCode}');
    }
  }

//List<SignalInfoModel>
  Future<void> getSignalInfo() async {
    List<SignalInfoModel> signalInfoInstances = [];
    final url = Uri.parse('$signalInfoUrl?apiKey=$apiKey&itstId=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final signalInfos = jsonDecode(response.body);
      for (var signalInfo in signalInfos) {
        signalInfoInstances.add(SignalInfoModel.fromJson(signalInfo));
      }
      // print('Signal Info Instance: $signalInfoInstances');
      // return signalInfoInstances;
    } else {
      throw Exception(
          'Failed to fetch signal info. Status code: ${response.statusCode}');
    }
  }
}
