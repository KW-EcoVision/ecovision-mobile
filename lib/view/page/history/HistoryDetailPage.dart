import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:eco_vision/model/HistoryData.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HistoryDetailPage extends StatefulWidget {
  final HistoryData historyData;
  final int level;
  const HistoryDetailPage(
      {super.key, required this.historyData, required this.level});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  ScreenshotController screenshotController = ScreenshotController();
  Future<XFile> share() async {
    return screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((onValue) async {
      if (onValue == null) {
        print("null!");
      }
      var buffer = onValue?.buffer;
      ByteData byteData = ByteData.view(buffer!);
      File file = await File('img.jpg').writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      return XFile(file.path);
    });
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }

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
              onPressed: () async {
                screenshotController
                    .capture(delay: Duration(milliseconds: 10))
                    .then((capturedImage) async {
                  Image.memory(capturedImage!);
                  XFile image = XFile.fromData(capturedImage,
                      name: 'record.jpg', mimeType: 'image/jpeg');
                  await Share.shareXFiles([image]);
                }).catchError((onError) {
                  print(onError);
                });
              },
              icon: const Icon(
                Icons.ios_share_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: SafeArea(
        child: Screenshot(
          controller: screenshotController,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.historyData.location,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
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
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                          'assets/images/avatar/${widget.level}.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
