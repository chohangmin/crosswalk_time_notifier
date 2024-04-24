import 'dart:convert';
import 'dart:io';

import 'package:crosswalk_time_notifier/models/remain_time_model.dart';
import 'package:crosswalk_time_notifier/models/signal_info_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';

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
    final url = Uri.parse('$remainTimeUrl?apiKey=$apiKey&itstId=$id');
    print('$remainTimeUrl?apiKey=$apiKey&itstId=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final remainTimes = jsonDecode(response.body);
      for (var remainTime in remainTimes) {
        var instance = RemainTimeModel.fromJson(remainTime);
        print('check rt: $instance');
        remainTimeInstances.add(instance);
      }
      // saveRtToJsonFile(remainTimeInstances);
      // print('Remain Time : $remainTimeInstances');
      // return remainTimeInstances;
    } else {
      throw Exception(
          'Failed to fetch signal info. Status code: ${response.statusCode}');
    }
  }

//List<SignalInfoModel>
  Future<void> getSignalInfo() async {
    List<SignalInfoModel> signalInfoInstances = [];
    final url = Uri.parse('$signalInfoUrl?apiKey=$apiKey');
    print('$signalInfoUrl?apiKey=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final signalInfos = jsonDecode(response.body);
      for (var signalInfo in signalInfos) {
        var instance = SignalInfoModel.fromJson(signalInfo);
        // print('check si : $instance');
        signalInfoInstances.add(instance);
      }
      // saveSiToJsonFile(signalInfoInstances);
      // print('Signal Info Instance: $signalInfoInstances');
      // return signalInfoInstances;
    } else {
      throw Exception(
          'Failed to fetch signal info. Status code: ${response.statusCode}');
    }
  }

  void saveRtToJsonFile(List<RemainTimeModel> instances) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory newDirectory =
        await Directory('${appDocDirectory.path}/dir').create(recursive: true);
    print('Path of New Dir: ${newDirectory.path}');

    var filename = '${newDirectory.path}/remain_time.json';
    print('1');
    var jsonContent =
        jsonEncode(instances.map((model) => model.toJson()).toList());
    print('2');

    saveFileToExternalStorage('remain_time.json', jsonContent);
    File(filename).writeAsStringSync(jsonContent);
    print('File saved : $filename');
  }

  void saveSiToJsonFile(List<SignalInfoModel> instances) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory newDirectory =
        await Directory('${appDocDirectory.path}/dir').create(recursive: true);
    print('Path of New Dir: ${newDirectory.path}');
    var filename = '${newDirectory.path}/signal_info.json';
    var jsonContent =
        jsonEncode(instances.map((model) => model.toJson()).toList());

    saveFileToExternalStorage('signal_info.json', jsonContent);
    File(filename).writeAsStringSync(jsonContent);
    print('File saved : $filename');
  }

  void saveFileToExternalStorage(String filename, String content) async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String filePath = '${directory.path}/$filename';
      File file = File(filePath);
      file.writeAsString(content);
      print('File saved to external storage: $filePath');
    } else {
      print('Error accessing external storage directory.');
    }
  }
}
