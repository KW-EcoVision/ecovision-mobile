import 'package:eco_vision/model/HistoryData.dart';
import 'package:eco_vision/service/HistoryTest.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isHistoriesInitialized = false;
  late List<HistoryData> histories;
  HistoryTest test = HistoryTest();

  @override
  void initState() {
    super.initState();
    // test대신 기록 받아오는 api 넣기

    test.testDataInit().then((_) {
      setState(() {
        histories = test.getHistories();
        isHistoriesInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoVisionColor.background,
      appBar: AppBar(
        backgroundColor: EcoVisionColor.background,
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: isHistoriesInitialized
            ? histories.isNotEmpty
                ? ListView.builder(
                    itemCount: histories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        width: MediaQuery.of(context).size.width - 20,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {},
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                  '장소: ${histories[index].location}\n시간: ${histories[index].time}분\n거리: ${histories[index].distance}km\n주운 쓰레기: ${histories[index].trashCount}개'),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('기록이 없습니다.'),
                  )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
