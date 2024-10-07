import 'package:eco_vision/model/SignupData.dart';
import 'package:eco_vision/service/NameValidator.dart';
import 'package:eco_vision/service/PasswordValidator.dart';
import 'package:eco_vision/service/UserIdValidator.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/widget/EcoButton.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupData userData = SignupData();
  UserIdValidator userIdValidator = UserIdValidator();
  NameValidator nameValidator = NameValidator();
  PasswordValidator passwordValidator = PasswordValidator();
  String confirmPassword = "";
  bool isNotDuplicated = false;

  // 유효성에 따른 경계 색상 반환
  Color borderColorByValid(bool? isValid) {
    if (isValid == null) {
      return Colors.white; // 초기 상태
    }
    return isValid ? EcoVisionColor.neonGreen : Colors.red; // 유효성에 따라 색상 설정
  }

  Color borderColorByValidForId(bool? isValid) {
    if (isValid == null) {
      return Colors.white; // 초기 상태
    }
    return (isValid && isNotDuplicated)
        ? EcoVisionColor.neonGreen
        : Colors.red; // 유효성에 따라 색상 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoVisionColor.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset('assets/images/signup.png')),
              Column(
                children: [
                  EcoTextField(
                    prefixIcon: const Icon(Icons.badge_outlined),
                    labelText: 'Name',
                    width: MediaQuery.of(context).size.width - 26,
                    height: MediaQuery.of(context).size.height / 11,
                    enabledBorderColor:
                        borderColorByValid(nameValidator.isValid),
                    focusedBorderColor:
                        borderColorByValid(nameValidator.isValid),
                    radius: 10,
                    isPassword: false,
                    onChanged: (value) {
                      userData.name = value;
                      nameValidator.isValid =
                          nameValidator.validate(userData.name);
                      setState(() {}); // UI 업데이트
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
                  EcoTextField(
                    prefixIcon: const Icon(Icons.person_outline_sharp),
                    labelText: 'ID',
                    width: MediaQuery.of(context).size.width - 26,
                    height: MediaQuery.of(context).size.height / 11,
                    enabledBorderColor:
                        borderColorByValidForId(userIdValidator.isValid),
                    focusedBorderColor:
                        borderColorByValidForId(userIdValidator.isValid),
                    radius: 10,
                    isPassword: false,
                    suffix: !(userIdValidator.validate(userData.userId))
                        ? null
                        : TextButton(
                            onPressed: () {
                              isNotDuplicated = !isNotDuplicated;
                              // 아이디 중복검사 추가
                              setState(() {});
                            },
                            child: const Text('중복검사')),
                    onChanged: (value) {
                      isNotDuplicated = false;
                      userData.userId = value;
                      userIdValidator.isValid =
                          userIdValidator.validate(userData.userId);
                      setState(() {}); // UI 업데이트
                    },
                  ),
                  SizedBox(
                    child: (userIdValidator.validate(userData.userId) ||
                            userData.userId.isEmpty)
                        ? null
                        : SizedBox(
                            width: MediaQuery.of(context).size.width - 26,
                            child: const Text(
                              '  아이디는 5글자 이상 20글자 이하여야 합니다.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                  ),
                  EcoTextField(
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    labelText: 'Password',
                    width: MediaQuery.of(context).size.width - 26,
                    height: MediaQuery.of(context).size.height / 11,
                    enabledBorderColor:
                        borderColorByValid(passwordValidator.isValid),
                    focusedBorderColor:
                        borderColorByValid(passwordValidator.isValid),
                    radius: 10,
                    isPassword: true,
                    onChanged: (value) {
                      userData.password = value;
                      passwordValidator.isValid =
                          passwordValidator.validate(userData.password);
                      setState(() {});
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
                    height: MediaQuery.of(context).size.height / 11,
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
              Center(
                child: EcoButton(
                    onPressed: () {
                      if ((nameValidator.validate(userData.name)) &&
                          (userIdValidator.validate(userData.userId)) &&
                          (passwordValidator.validate(userData.password)) &&
                          (userData.password == confirmPassword) &&
                          isNotDuplicated) {
                        // 회원가입 요청 추가
                        Navigator.pop(context);
                      }
                    },
                    text: 'OK',
                    radius: 10,
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height / 17,
                    backgroundColor: (((nameValidator
                                .validate(userData.name)) &&
                            (userIdValidator.validate(userData.userId)) &&
                            (passwordValidator.validate(userData.password)) &&
                            (userData.password == confirmPassword) &&
                            isNotDuplicated)
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
