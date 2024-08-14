import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/SignupPage.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Center(
              child: Text(
                'Eco Vision',
                style: TextStyle(fontSize: 40),
              ),
            ),
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
                    isPassword: false),
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
                    isPassword: true),
                // SizedBox(
                // height: MediaQuery.of(context).size.height / 100,
                // child:
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Row(
                    children: [
                      const Text(' 아직 회원이 아니신가요?'),
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
                    // ),
                  ),
                ),
              ],
            ),
            Center(
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 15),
                    )))
          ],
        ),
      ),
    );
  }
}
