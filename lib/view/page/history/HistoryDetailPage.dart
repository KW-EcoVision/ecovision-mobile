import 'package:eco_vision/model/HistoryData.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/MainFrame.dart';
import 'package:eco_vision/view/page/history/HistoryPage.dart';
import 'package:eco_vision/view/widget/EcoAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDetailPage extends StatefulWidget {
  final HistoryData historyData;
  const HistoryDetailPage({super.key, required this.historyData});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoVisionColor.background,
      appBar: AppBar(
        backgroundColor: EcoVisionColor.background,
        title: const Text(
          '플로깅 기록',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return EcoAlertDialog(
                        title: '플로깅 기록을 삭제하시겠습니까?',
                        content: '해당 플로깅에 대한 데이터가 삭제되며 다시 복구할 수 없습니다.',
                        acceptFunction: () {
                          // Navigator.of(context).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const MainFrame(
                                        index: 2,
                                      )),
                              (route) => false);
                        },
                        cancelFunction: () {
                          Navigator.pop(context);
                        },
                      );
                    });
              },
              icon: const Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.historyData.location,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                '${DateFormat.yMMMd().format(widget.historyData.createdAt)}\n',
                style: const TextStyle(color: Colors.grey),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: Text(
                    '\n거리\n',
                    style: TextStyle(color: Colors.grey),
                  )),
                  Expanded(
                      child: Text(
                    '\n시간\n',
                    style: TextStyle(color: Colors.grey),
                  )),
                  Expanded(
                      child: Text(
                    '\n주운 쓰레기\n',
                    style: TextStyle(color: Colors.grey),
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '${widget.historyData.distance}m',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${widget.historyData.time}분',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${widget.historyData.trashCount}개',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
              const Text('\n'),
              SizedBox(
                height: MediaQuery.of(context).size.width - 20,
                child: const Card(
                  color: Colors.white,
                  child: Center(child: Text('뭐 넣지?')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
