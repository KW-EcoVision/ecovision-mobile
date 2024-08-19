import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/MainFrame.dart';
import 'package:eco_vision/view/page/SignupPage.dart';
import 'package:eco_vision/view/widget/EcoButton.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isIdEntered = false;
  bool isPasswordEnterd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset('assets/images/logo.jpeg'))),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EcoTextField(
                      prefixIcon: const Icon(Icons.person_outline_sharp),
                      labelText: 'ID',
                      width: MediaQuery.of(context).size.width - 32,
                      height: MediaQuery.of(context).size.height / 10,
                      enabledBorderColor: Colors.white,
                      focusedBorderColor: EcoVisionColor.neonGreen,
                      radius: 10,
                      isPassword: false,
                      onChanged: (value) {
                        setState(() {
                          isIdEntered = value.isNotEmpty;
                        });
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  EcoTextField(
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    labelText: 'Password',
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height / 10,
                    enabledBorderColor: Colors.white,
                    focusedBorderColor: EcoVisionColor.neonGreen,
                    radius: 10,
                    isPassword: true,
                    onChanged: (value) {
                      setState(() {
                        isPasswordEnterd = value.isNotEmpty;
                      });
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Row(
                      children: [
                        Text(
                          ' 아직 회원이 아니신가요?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Expanded(child: SizedBox()),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()));
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
                height: MediaQuery.of(context).size.height / 16,
                backgroundColor: (isIdEntered && isPasswordEnterd)
                    ? EcoVisionColor.mainGreen
                    : Colors.grey,
                onPressed: () {
                  if (isIdEntered && isPasswordEnterd) {
                    // 로그인 요청 추가
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainFrame()));
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
