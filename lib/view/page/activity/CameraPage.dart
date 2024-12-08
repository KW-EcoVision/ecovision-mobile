import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameraDescriptions;
  final CameraController cameraController;
  const CameraPage(
      {required this.cameraController,
      required this.cameraDescriptions,
      super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Dio dio = Dio();
  int trashCount = 0;
  int cameraIdx = 0;
  @override
  void dispose() {
    widget.cameraController.dispose();
    super.dispose();
  }

  Future<Map> getImageResponse(FormData formData) async {
    dio.options.contentType = 'multipart/form-data';
    var response =
        await dio.post("http://100.102.151.106:5000/detect", data: formData);
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(
            widget.cameraController,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Opacity(
                opacity: 0.6,
                child: Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop(trashCount);
                          },
                          icon: Icon(
                            Icons.exit_to_app_outlined,
                            size: MediaQuery.of(context).size.width / 13,
                          )),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 15),
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () async {
                              XFile pickedImage =
                                  await widget.cameraController.takePicture();
                              // MultipartFile.fromBytes(value)
                              MultipartFile image = MultipartFile.fromFileSync(
                                  pickedImage.path,
                                  contentType: MediaType('image', 'jpeg'));

                              FormData formData =
                                  FormData.fromMap({"image": image});
                              getImageResponse(formData).then(
                                (response) {
                                  String result = response['predictions'];
                                  setState(() {
                                    trashCount += 1;
                                  });
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('촬영 결과'),
                                        content: Column(
                                          children: [
                                            Image(
                                                image: FileImage(
                                                    File(pickedImage.path))),
                                            Text('판별 결과 : $result'),
                                          ],
                                        ),
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
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.camera_outlined,
                              size: MediaQuery.of(context).size.width / 5,
                            )),
                      ),
                      IconButton(
                        color: Colors.white,
                        onPressed: () {
                          if (cameraIdx == 0) {
                            cameraIdx = 1;
                          } else {
                            cameraIdx = 0;
                          }
                          setState(() {
                            widget.cameraController.setDescription(
                                widget.cameraDescriptions[cameraIdx]);
                          });
                        },
                        icon: Icon(
                          Icons.refresh,
                          size: MediaQuery.of(context).size.width / 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
