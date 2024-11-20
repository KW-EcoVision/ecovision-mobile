import 'dart:convert';
import 'package:eco_vision/model/EditPasswordData.dart';
import 'package:eco_vision/service/PasswordValidator.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/MainFrame.dart';
import 'package:eco_vision/view/widget/EcoButton.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  PasswordValidator passwordValidator = PasswordValidator();
  EditPasswordData userData = EditPasswordData();
  String confirmPassword = "";

  Color borderColorByValid(bool? isValid) {
    if (isValid == null) {
      return Colors.white; // 초기 상태
    }
    return isValid ? EcoVisionColor.neonGreen : Colors.red; // 유효성에 따라 색상 설정
  }

  Future<http.Response> editPassword() async {
    late String token;
    late SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken')!;

    return await http.put(Uri.parse("http://43.201.1.7:8080/update-password"),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: json.encode({'password': userData.password}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '비밀번호 변경',
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
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    labelText: 'Password',
                    width: MediaQuery.of(context).size.width - 26,
                    height: MediaQuery.of(context).size.height / 10,
                    enabledBorderColor:
                        borderColorByValid(passwordValidator.isValid),
                    focusedBorderColor:
                        borderColorByValid(passwordValidator.isValid),
                    radius: 10,
                    isPassword: true,
                    onChanged: (value) {
                      setState(() {
                        userData.password = value;
                        passwordValidator.isValid =
                            passwordValidator.validate(userData.password);
                      });
                    },
                  ),
                  SizedBox(
                    child: (passwordValidator.validate(userData.password) ||
                            userData.password.isEmpty)
                        ? null
                        : SizedBox(
                            width: MediaQuery.of(context).size.width - 26,
                            child: const Text(
                              '  비밀번호는 영문자와 숫자를 포함하여 9자 이상이어야 합니다.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                  ),
                  EcoTextField(
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    labelText: 'Confirm Password',
                    width: MediaQuery.of(context).size.width - 26,
                    height: MediaQuery.of(context).size.height / 10,
                    enabledBorderColor: borderColorByValid(
                        confirmPassword.isEmpty
                            ? null
                            : (userData.password == confirmPassword)),
                    focusedBorderColor: borderColorByValid(
                        confirmPassword.isEmpty
                            ? null
                            : (userData.password == confirmPassword)),
                    radius: 10,
                    isPassword: true,
                    onChanged: (value) {
                      confirmPassword = value;
                      setState(() {}); // UI 업데이트
                    },
                  ),
                ],
              ),
              EcoButton(
                onPressed: () {
                  if ((passwordValidator.validate(userData.password)) &&
                      (userData.password == confirmPassword)) {
                    editPassword().then((response) {
                      if (response.statusCode == 200) {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('비밀번호 변경 완료'),
                                content: const Text('비밀번호가 변경되었습니다'),
                                actions: [
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(
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
                          content: const Text('비밀번호 변경에 실패하였습니다.\n다시 시도해주세요.'),
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
                backgroundColor:
                    ((((passwordValidator.validate(userData.password)) &&
                            (userData.password == confirmPassword))
                        ? EcoVisionColor.mainGreen
                        : Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
