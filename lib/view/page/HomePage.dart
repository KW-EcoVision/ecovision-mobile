import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'bmjua',
            // color: EcoVisionColor.mainGreen
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8, 16, 8, 16),
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  height: MediaQuery.of(context).size.width / 2 - 24,
                  child: Card(
                    child: Center(
                      child: Text('data1'),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(8, 16, 8, 16),
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    height: MediaQuery.of(context).size.width / 2 - 24,
                    child: Card(
                      child: Center(
                        child: Text('data2'),
                      ),
                    ))
              ],
            ),
            Container(
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                width: MediaQuery.of(context).size.width - 32,
                height: MediaQuery.of(context).size.width / 2 - 32,
                child: Card(
                  child: Center(
                    child: Text('data3'),
                  ),
                )),
          ],
        )),
      ),
    );
  }
}
