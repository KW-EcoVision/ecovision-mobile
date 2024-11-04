import 'package:eco_vision/model/HistoryData.dart';
import 'package:eco_vision/service/HistoryTest.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/history/HistoryDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isHistoriesInitialized = false;
  late List<HistoryData> histories;
  // late String token;
  // late SharedPreferences prefs;
  // late Future<http.Response> response;
  HistoryTest test = HistoryTest();

  @override
  void initState() async {
    super.initState();
    // // test대신 기록 받아오는 api 넣기
    // prefs = await SharedPreferences.getInstance();
    // token = prefs.getString('accessToken')!;

    // response = http.get(Uri.parse("http://43.201.1.7:8080/total-and-list-view"),
    //     headers: {'Content-Type': 'application/json', 'Authorization': token});

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
        child: ListView(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 2,
                      child: Card(
                        color: Colors.white,
                        child: Center(child: Text('아바타 그림')),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: Text(
                            '\n총 거리\n',
                            style: TextStyle(color: Colors.grey),
                          )),
                          Expanded(
                              child: Text(
                            '\n총 시간\n',
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
                                '9999m',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '999분',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '99개',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('\n'),
                    Container(
                        margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: const Text('기록',
                            style: TextStyle(color: Colors.grey)))
                  ],
                )),
            isHistoriesInitialized
                ? histories.isNotEmpty
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
                                        builder: (context) => HistoryDetailPage(
                                              historyData: histories[index],
                                            )));
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
                                            // fontSize: 20,
                                            // fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    )
                                    // Text(

                                    //     '장소: ${histories[index].location}\n시간: ${histories[index].time}분\n거리: ${histories[index].distance}km\n주운 쓰레기: ${histories[index].trashCount}개'),
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
          ],
        ),
      ),
    );
  }
}
