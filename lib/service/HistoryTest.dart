import 'dart:math';

import 'package:eco_vision/model/HistoryData.dart';

class HistoryTest {
  int randomLength = Random().nextInt(10);
  late List<HistoryData> histories = [];

  Future<void> testDataInit() async {
    histories = [];
    int randomLength = Random().nextInt(10);
    int i = 0;

    while (i <= randomLength) {
      String randomLocation = "서울시 노원구";
      int randomTime = Random().nextInt(50);
      int randomDistance = Random().nextInt(10);
      int randomTrashCount = Random().nextInt(10);
      DateTime randomCreatedAt = DateTime.now();

      HistoryData data = HistoryData(
        location: randomLocation,
        time: randomTime,
        distance: randomDistance,
        trashCount: randomTrashCount,
        createdAt: randomCreatedAt,
      );

      histories.add(data);
      i++;
    }
    await Future.delayed(const Duration(seconds: 1)); // 테스트용 2초 딜레이
  }

  List<HistoryData> getHistories() {
    return histories;
  }
}
