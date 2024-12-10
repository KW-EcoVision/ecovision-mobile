import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/MainFrame.dart';
import 'package:eco_vision/view/page/SignupPage.dart';
import 'package:eco_vision/view/widget/EcoButton.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String userId;
  late String password;
  bool isIdEntered = false;
  bool isPasswordEnterd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoVisionColor.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset('assets/images/logo.png'))),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EcoTextField(
                      prefixIcon: const Icon(Icons.person_outline_sharp),
                      labelText: 'ID',
                      width: MediaQuery.of(context).size.width - 26,
                      height: MediaQuery.of(context).size.height / 11,
                      enabledBorderColor: Colors.white,
                      focusedBorderColor: EcoVisionColor.neonGreen,
                      radius: 10,
                      isPassword: false,
                      onChanged: (value) {
                        setState(() {
                          userId = value;
                          isIdEntered = value.isNotEmpty;
                        });
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  EcoTextField(
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    labelText: 'Password',
                    width: MediaQuery.of(context).size.width - 26,
                    height: MediaQuery.of(context).size.height / 11,
                    enabledBorderColor: Colors.white,
                    focusedBorderColor: EcoVisionColor.neonGreen,
                    radius: 10,
                    isPassword: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        isPasswordEnterd = value.isNotEmpty;
                      });
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Row(
                      children: [
                        const Text(
                          ' 아직 회원이 아니신가요?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Expanded(child: SizedBox()),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupPage()));
                            },
                            child: const Text('Sign up'))
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: EcoButton(
                  text: 'Login',
                  radius: 10,
                  width: MediaQuery.of(context).size.width - 32,
                  height: MediaQuery.of(context).size.height / 17,
                  backgroundColor: (isIdEntered && isPasswordEnterd)
                      ? EcoVisionColor.mainGreen
                      : Colors.grey,
                  onPressed: () async {
                    if (isIdEntered && isPasswordEnterd) {
                      final http.Response response = await http.post(
                          Uri.parse("http://43.201.1.7:8080/login"),
                          headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                          },
                          body: {
                            'username': userId,
                            'password': password
                          });
                      if (response.statusCode == 200) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.setString(
                            'accessToken', response.headers['authorization']!);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainFrame()));
                      } else {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('로그인에 실패했습니다'),
                                content:
                                    const Text('아이디와 비밀번호를 확인하고 다시 시도해주세요'),
                                actions: [
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("확인"),
                                  ),
                                ],
                              );
                            });
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
