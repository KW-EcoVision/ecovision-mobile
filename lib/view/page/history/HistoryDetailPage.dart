import 'package:eco_vision/model/HistoryData.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
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
              Text('\n'),
              SizedBox(
                height: MediaQuery.of(context).size.width - 20,
                child: Card(
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
