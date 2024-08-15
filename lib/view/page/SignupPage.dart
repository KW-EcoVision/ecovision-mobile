import 'package:eco_vision/model/SignupData.dart';
import 'package:eco_vision/service/SignupValidator.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupData userData = SignupData();
  SignupValidator validator = SignupValidator();
  String? confirmPassword = "";

  // 유효성에 따른 경계 색상 반환
  Color borderColorByValid(bool? isValid) {
    if (isValid == null) {
      return Colors.white; // 초기 상태
    }
    return isValid ? EcoVisionColor.neonGreen : Colors.red; // 유효성에 따라 색상 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Column(
                children: [
                  EcoTextField(
                    prefixIcon: const Icon(Icons.badge_outlined),
                    labelText: 'Name',
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height / 10,
                    enabledBorderColor:
                        borderColorByValid(validator.isValidName),
                    focusedBorderColor:
                        borderColorByValid(validator.isValidName),
                    radius: 10,
                    isPassword: false,
                    onChanged: (value) {
                      userData.name = value;
                      validator.isValidName =
                          validator.validateName(userData.name!);
                      setState(() {}); // UI 업데이트
                    },
                  ),
                  EcoTextField(
                    prefixIcon: const Icon(Icons.person_outline_sharp),
                    labelText: 'ID',
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height / 10,
                    enabledBorderColor:
                        borderColorByValid(validator.isValidUserId),
                    focusedBorderColor:
                        borderColorByValid(validator.isValidUserId),
                    radius: 10,
                    isPassword: false,
                    onChanged: (value) {
                      userData.userId = value;
                      validator.isValidUserId =
                          validator.validateUserId(userData.userId!);
                      setState(() {}); // UI 업데이트
                    },
                  ),
                  EcoTextField(
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    labelText: 'Password',
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height / 10,
                    enabledBorderColor:
                        borderColorByValid(validator.isValidPassword),
                    focusedBorderColor:
                        borderColorByValid(validator.isValidPassword),
                    radius: 10,
                    isPassword: true,
                    onChanged: (value) {
                      userData.password = value;
                      validator.isValidPassword =
                          validator.validatePassword(userData.password!);
                      setState(() {});
                    },
                  ),
                  EcoTextField(
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    labelText: 'Confirm Password',
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height / 10,
                    enabledBorderColor: borderColorByValid(
                        confirmPassword!.isEmpty
                            ? null
                            : (userData.password == confirmPassword)),
                    focusedBorderColor: borderColorByValid(
                        confirmPassword!.isEmpty
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
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 15),
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
