import 'dart:convert';

import 'package:eco_vision/model/EditInfoData.dart';
import 'package:eco_vision/service/NameValidator.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/MainFrame.dart';
import 'package:eco_vision/view/widget/EcoButton.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({super.key});

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  NameValidator nameValidator = NameValidator();
  EditInfoData userData = EditInfoData();

  Color borderColorByValid(bool? isValid) {
    if (isValid == null) {
      return Colors.white; // 초기 상태
    }
    return isValid ? EcoVisionColor.neonGreen : Colors.red; // 유효성에 따라 색상 설정
  }

  Future<http.Response> editName() async {
    late String token;
    late SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken')!;

    return await http.put(Uri.parse("http://43.201.1.7:8080/update-name"),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: json.encode({'name': userData.name}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '내 정보 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(),
              Column(
                children: [
                  EcoTextField(
                    prefixIcon: const Icon(Icons.badge_outlined),
                    labelText: 'Name',
                    width: MediaQuery.of(context).size.width - 26,
                    height: MediaQuery.of(context).size.height / 10,
                    enabledBorderColor:
                        borderColorByValid(nameValidator.isValid),
                    focusedBorderColor:
                        borderColorByValid(nameValidator.isValid),
                    radius: 10,
                    isPassword: false,
                    onChanged: (value) {
                      setState(() {
                        userData.name = value;
                        nameValidator.isValid =
                            nameValidator.validate(userData.name);
                      }); // UI 업데이트
                    },
                  ),
                  SizedBox(
                    child: (nameValidator.validate(userData.name) ||
                            userData.name.isEmpty)
                        ? null
                        : SizedBox(
                            width: MediaQuery.of(context).size.width - 26,
                            child: const Text(
                              '  이름은 영문 또는 한글로 1자 이상이어야 합니다.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                  ),
                ],
              ),
              EcoButton(
                  onPressed: () {
                    if ((nameValidator.validate(userData.name))) {
                      editName().then((response) {
                        if (response.statusCode == 200) {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text('이름 변경 완료'),
                                  content: const Text('이름이 변경되었습니다'),
                                  actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MainFrame(
                                                          index: 3,
                                                        )),
                                                (route) => false);
                                      },
                                      child: const Text("확인"),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          return CupertinoAlertDialog(
                            title: const Text('오류가 발생하였습니다'),
                            content: const Text('이름 변경에 실패하였습니다.\n다시 시도해주세요.'),
                            actions: [
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => const MainFrame(
                                                index: 3,
                                              )),
                                      (route) => false);
                                },
                                child: const Text("확인"),
                              ),
                            ],
                          );
                        }
                      });
                    }
                  },
                  text: 'OK',
                  radius: 10,
                  width: MediaQuery.of(context).size.width - 32,
                  height: MediaQuery.of(context).size.height / 17,
                  backgroundColor: (((nameValidator.validate(userData.name)))
                      ? EcoVisionColor.mainGreen
                      : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
