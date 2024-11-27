import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
// import 'package:eco_vision/model/CreatePloggingData.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/activity/CameraPage.dart';
import 'package:eco_vision/view/page/MainFrame.dart';
import 'package:eco_vision/view/widget/EcoAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:http/http.dart' as http;

class PloggingBottomSheet extends StatefulWidget {
  final String currentLocation;
  const PloggingBottomSheet({super.key, required this.currentLocation});

  @override
  State<PloggingBottomSheet> createState() => _PloggingBottomSheetState();
}

class _PloggingBottomSheetState extends State<PloggingBottomSheet> {
  Stream<Position> positionStream = Geolocator.getPositionStream(
      locationSettings:
          const LocationSettings(distanceFilter: 1 // 위치 변화가 1미터 이상일 때만 업데이트
              ));
  late StreamSubscription<Position> positionSubscription;

  Location location = Location();
  late LocationData locationData;

  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  late List<CameraDescription> descriptions;
  late CameraController cameraController;
  bool isCameraInitialized = false;

  double currentSpeed = 0;
  double lastLatitude = 0;
  double lastLongitude = 0;
  double distanceStack = 0;

  late int recordTime;
  late int recordDistance;
  // late String recordLocation;
  int recordTrashCount = 0;

  Future<void> initCamera() async {
    descriptions = await availableCameras();
    cameraController = CameraController(descriptions[0], ResolutionPreset.high);
    await cameraController.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  void plogingStart() async {
    _listenToPositionUpdates();
    stopWatchTimer.onStartTimer();
  }

  void plogingStop() {
    stopWatchTimer.onStopTimer();
    stopWatchTimer.dispose(); // 타이머 해제
  }

  Future<void> _listenToPositionUpdates() async {
    locationData = await location.getLocation();
    lastLatitude = locationData.latitude!;
    lastLongitude = locationData.longitude!;

    positionSubscription = positionStream.listen((Position position) {
      double interval = 0;

      if (position.speed >= 1) {
        interval = Geolocator.distanceBetween(
            lastLatitude, lastLongitude, position.latitude, position.longitude);
        lastLatitude = position.latitude;
        lastLongitude = position.longitude;
      }

      setState(() {
        distanceStack += interval / 1000;
        recordDistance = (distanceStack * 1000).toInt(); // 미터단위
        lastLatitude;
        lastLongitude;
        currentSpeed = position.speed * 3.6; // 속도 업데이트
      });
    });
  }

  Future<void> createPloggingRecord() async {
    late String token;
    late SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken')!;

    // CreatePloggingData createPloggingData = CreatePloggingData(
    //     distance: recordDistance,
    //     trashCount: recordTrashCount,
    //     location: widget.currentLocation,
    //     time: recordTime);

    await http.post(Uri.parse("http://43.201.1.7:8080/plogging/record"),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: json.encode({
          "distance": recordDistance,
          "trashCount": recordTrashCount,
          "location": widget.currentLocation,
          "time": recordTime
        }));
  }

  @override
  void initState() {
    super.initState();
    plogingStart();
  }

  @override
  void dispose() {
    plogingStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: EcoVisionColor.background,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(' '),
            Expanded(
              child: GridView(
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.7,
                ),
                children: [
                  Center(
                    child: StreamBuilder<int>(
                        stream: stopWatchTimer.rawTime,
                        builder: (context, snap) {
                          final int value = (snap.hasData) ? snap.data! : 0;
                          recordTime = value ~/ 60000; // 분단위
                          final String displayTime = (value < 3600000)
                              ? StopWatchTimer.getDisplayTime(value,
                                  hours: false, milliSecond: false)
                              : StopWatchTimer.getDisplayTime(value,
                                  second: false, milliSecond: false);
                          return Column(
                            children: [
                              Text(
                                displayTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 24,
                                ),
                              ),
                              Text(
                                (value < 3600000) ? '분' : '시간',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 60,
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Center(
                      child: Column(
                    children: [
                      Text(
                        '$recordTrashCount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 24,
                        ),
                      ),
                      Text(
                        '쓰레기',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.height / 60,
                        ),
                      ),
                    ],
                  )),
                  Center(
                      child: Column(
                    children: [
                      Text(
                        distanceStack.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 24,
                        ),
                      ),
                      Text(
                        'km',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.height / 60,
                        ),
                      )
                    ],
                  )),
                  Center(
                      child: Column(
                    children: [
                      Text(
                        currentSpeed.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 24,
                        ),
                      ),
                      Text(
                        'km/h',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.height / 60,
                        ),
                      )
                    ],
                  )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () async {
                      await initCamera();
                      if (isCameraInitialized) {
                        int? trashCount = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPage(
                              cameraController: cameraController,
                              cameraDescriptions: descriptions,
                            ),
                          ),
                        );
                        if (trashCount != null) {
                          setState(() {
                            recordTrashCount += trashCount;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Camera is not initialized yet!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.camera_alt_outlined)),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    heroTag: "1",
                    backgroundColor: EcoVisionColor.mainGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.stop,
                      color: Colors.white,
                      size: 65,
                    ),
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return EcoAlertDialog(
                              title: '플로깅을 중단하시겠습니까?',
                              content: '현재까지의 기록이 저장됩니다.',
                              acceptFunction: () {
                                stopWatchTimer.onStopTimer();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) {
                                  createPloggingRecord();
                                  return const MainFrame();
                                }), (route) => false);
                              },
                              cancelFunction: () {
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('도움말'),
                              content: const Text(
                                  '"카메라 버튼"을 눌러 습득한 쓰레기를 촬영하면 쓰레기 카운트가 증가합니다.'),
                              actions: [
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: const Text('확인'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.question_mark_outlined))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
