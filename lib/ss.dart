import 'dart:async';

import 'package:flutter/material.dart';

class FlagScreen extends StatefulWidget {
  @override
  _FlagScreenState createState() => _FlagScreenState();
}

class _FlagScreenState extends State<FlagScreen> {
  bool showFlag = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 10), () {
      setState(() {
        showFlag = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!showFlag)
              Text(
                'Counting...',
                style: TextStyle(fontSize: 24),
              ),
            if (showFlag)
              FlutterLogo(
                size: 150,
              ),
          ],
        ),
      ),
    );
  }
}


