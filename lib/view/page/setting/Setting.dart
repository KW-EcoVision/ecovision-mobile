import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/LoginPage.dart';
import 'package:eco_vision/view/page/setting/EditInfoPage.dart';
import 'package:eco_vision/view/page/setting/EditPasswordPage.dart';
import 'package:eco_vision/view/page/setting/ServiceTermPage.dart';
import 'package:eco_vision/view/widget/EcoAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoVisionColor.background,
      appBar: AppBar(
        backgroundColor: EcoVisionColor.background,
        title: const Text(
          'Setting',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  width: MediaQuery.of(context).size.width - 20,
                  child: Card(
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          title: const Text(
                            '내 정보 수정',
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditInfoPage()));
                          },
                        ),
                        // Divider(),
                        ListTile(
                          title: const Text(
                            '비밀번호 변경',
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditPasswordPage()));
                          },
                        ),
                        ListTile(
                          title: const Text(
                            '위치 기반 서비스 이용약관',
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ServiceTermPage()));
                          },
                        ),
                        // Divider(),
                        ListTile(
                          title: const Text(
                            '로그아웃',
                          ),
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                        ),
                      ],
                    ),
                  )),
              Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                width: MediaQuery.of(context).size.width - 20,
                // height: MediaQuery.of(context).size.width / 3 - 32,
                child: Card(
                  color: Colors.white,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        title: const Text(
                          '계정 탈퇴',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return EcoAlertDialog(
                                  title: '계정을 삭제하시겠습니까?',
                                  content: '당신의 모든 데이터가 삭제되며 다시 복구할 수 없습니다.',
                                  acceptFunction: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                        (route) => false);
                                  },
                                  cancelFunction: () {
                                    Navigator.pop(context);
                                  },
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
