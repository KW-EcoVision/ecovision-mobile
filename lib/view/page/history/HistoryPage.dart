import 'package:eco_vision/model/HistoryData.dart';
import 'package:eco_vision/model/TotalData.dart';
import 'package:eco_vision/service/HistoryService.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/history/HistoryDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isHistoriesInitialized = false;
  late List<HistoryData> histories;
  late TotalData totalData;
  late String token;
  late SharedPreferences prefs;
  HistoryService service = HistoryService();

  @override
  void initState() {
    super.initState();
    service.testDataInit().then((_) {
      setState(() {
        histories = service.getHistories();
        totalData = service.getTotalData();
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
            ? ListView(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                  'assets/images/avatar/${totalData.level}.png'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    child: Text(
                                  '\n총 거리 (m)\n',
                                  style: TextStyle(color: Colors.grey),
                                )),
                                Expanded(
                                    child: Text(
                                  '\n총 시간 (분)\n',
                                  style: TextStyle(color: Colors.grey),
                                )),
                                Expanded(
                                    child: Text(
                                  '\n총 주운 쓰레기\n',
                                  style: TextStyle(color: Colors.grey),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '${totalData.totalDistance}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '${totalData.totalTime}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '${totalData.trashCount}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text('\n'),
                          Container(
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: const Text('기록',
                                  style: TextStyle(color: Colors.grey)))
                        ],
                      )),
                  histories.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: histories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              width: MediaQuery.of(context).size.width - 20,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HistoryDetailPage(
                                                  historyData: histories[index],
                                                  level: totalData.level)));
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          histories[index].location,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '\n${DateFormat('yyyy년 MM월 dd일 ').format(histories[index].createdAt)}'
                                          '${DateFormat.E('ko_KR').format(histories[index].createdAt)}요일',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('기록이 없습니다.'),
                        ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
