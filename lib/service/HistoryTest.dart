import 'dart:convert';

import 'package:eco_vision/model/HistoryData.dart';
import 'package:eco_vision/model/TotalData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class HistoryTest {
  late String token;
  late SharedPreferences prefs;
  // late Future<http.Response> response;
  // int randomLength = Random().nextInt(10);
  late TotalData totaldata;
  late List<HistoryData> histories = [];

  Future<List<HistoryData>> testDataInit() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken')!;

    http.Response response = await http.get(
        Uri.parse("http://43.201.1.7:8080/plogging/total-and-list-view"),
        headers: {'Content-Type': 'application/json', 'Authorization': token});

    histories = [];

    if (response.statusCode == 404) {
      totaldata = TotalData(
          id: 0, totalDistance: 0, totalTime: 0, trashCount: 0, level: 1);
    } else {
      Map dto = jsonDecode(utf8.decode(response.bodyBytes));
      int i = 0;
      List list = dto['ploggingList'];

      totaldata = TotalData(
          id: dto['id'],
          totalDistance: dto['totalDistance'],
          totalTime: dto['totalTime'],
          trashCount: dto['totalCount'],
          level: dto['level']);

      while (i < list.length) {
        int id = list[i]['id'];
        String location = list[i]['location'].toString();
        int time = list[i]['time'];
        int distance = list[i]['distance'];
        int trashCount = list[i]['trashCount'];
        DateTime createdAt = DateTime.parse(list[i]['timeStamp']);

        HistoryData data = HistoryData(
          id: id,
          location: location,
          time: time,
          distance: distance,
          trashCount: trashCount,
          createdAt: createdAt,
        );

        histories.add(data);
        i++;
      }
    }
    return histories;

    // int randomLength = Random().nextInt(10);

    // await Future.delayed(const Duration(seconds: 1)); // 테스트용 2초 딜레이
  }

  List<HistoryData> getHistories() {
    return histories;
  }

  TotalData getTotalData() {
    return totaldata;
  }
}
