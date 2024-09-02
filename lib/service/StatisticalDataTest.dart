import 'dart:math';

import 'package:eco_vision/model/StatisticalData.dart';

class StatisticalDataTest {
  late int randomTime;
  late double randomDistance;
  late int randomTrashCount;
  late StatisticalData data;

  Future<void> initData() async {
    randomTime = Random().nextInt(50);
    randomDistance = Random().nextDouble();
    randomTrashCount = Random().nextInt(10);

    data = StatisticalData(
      time: randomTime.toString(),
      distance: randomDistance,
      trashCount: randomTrashCount,
    );

    await Future.delayed(const Duration(seconds: 1)); // 테스트용 2초 딜레이
  }

  StatisticalData getStatisticalData() {
    return data;
  }
}
