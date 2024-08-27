import 'package:eco_vision/model/EditInfoData.dart';
import 'package:eco_vision/service/NameValidator.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '내 정보 수정',
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EcoTextField(
              prefixIcon: const Icon(Icons.badge_outlined),
              labelText: 'Name',
              width: MediaQuery.of(context).size.width - 32,
              height: MediaQuery.of(context).size.height / 10,
              enabledBorderColor: borderColorByValid(nameValidator.isValid),
              focusedBorderColor: borderColorByValid(nameValidator.isValid),
              radius: 10,
              isPassword: false,
              onChanged: (value) {
                userData.name = value;
                nameValidator.isValid = nameValidator.validate(userData.name);
                setState(() {}); // UI 업데이트
              },
            ),
            SizedBox(
              child: (nameValidator.validate(userData.name) ||
                      userData.name.isEmpty)
                  ? null
                  : SizedBox(
                      width: MediaQuery.of(context).size.width - 32,
                      child: const Text(
                        '  이름은 영문 또는 한글로 1자 이상이어야 합니다.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
            ),
          ],
        ),
      )),
    );
  }
}
