import 'package:eco_vision/view/page/LoginPage.dart';
import 'package:eco_vision/view/page/setting/EditInfoPage.dart';
import 'package:eco_vision/view/page/setting/EditPasswordPage.dart';
import 'package:eco_vision/view/page/setting/ServiceTermPage.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Setting',
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                width: MediaQuery.of(context).size.width - 32,
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
                                  builder: (context) => EditInfoPage()));
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
                                  builder: (context) => EditPasswordPage()));
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
                                  builder: (context) => ServiceTermPage()));
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
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                width: MediaQuery.of(context).size.width - 32,
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
                        onTap: () {},
                      ),
                    ],
                  ),
                )),
          ],
        )),
      ),
    );
  }
}
