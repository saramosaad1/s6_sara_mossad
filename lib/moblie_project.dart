import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NoiseData {
  final double time;
  final double noiseLevel;
  NoiseData(this.time, this.noiseLevel);
}

class Noise extends StatefulWidget {
  @override
  _NoiseState createState() => _NoiseState();
}

class _NoiseState extends State<Noise> {

  NoiseMeter? _noiseMeter;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  List<NoiseData> _noiseDataList = <NoiseData>[];
  bool _isFlag = false;
  double _avarage =0;
  late int previousMillis;

  @override
  void initState() {
    super.initState();
    _noiseMeter =  NoiseMeter(onError);
    _startListening();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  /* start listening sounds */
  void _startListening()async {
    try{
      previousMillis = DateTime.now().millisecondsSinceEpoch;
      _noiseSubscription = _noiseMeter!.noiseStream.listen((NoiseReading noiseReading) {
        setState(() {
          _noiseDataList.add(NoiseData
            ((
              (DateTime
                  .now()
                  .millisecondsSinceEpoch - previousMillis) / 1000).toDouble(),
              noiseReading.meanDecibel));
        });
      });
      Timer.periodic(Duration(seconds: 10), (timer) {
        double average = _calculateAverage();
        _isFlag = average > 70;
        _avarage = average;
        Future.delayed(Duration(seconds: 2), () {
         _isFlag = false;
        // _avarage=0;
        });
        _noiseDataList.clear();
      });
    }catch(e){
      print("error");
    };
  }

  void _stopListening() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
  }

  double _calculateAverage() {
    double sum = 0;
    for (var noiseData in _noiseDataList) {
      sum += noiseData.noiseLevel;
    }
    return sum /_noiseDataList.length;
  }

  void onError(Object error) {
    print(error.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
          title: const Text('NOISE APPLICATION'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
             Center(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
                     'NOISE LEVEL NOW : ',
                     style: TextStyle(
                         fontSize: 17,
                         fontWeight: FontWeight.bold,
                         color: Colors.deepPurple[200]
                     ),
                   ),
                   Text(
                    '${_noiseDataList.isNotEmpty ? _noiseDataList.last.noiseLevel.toStringAsFixed(2) : '0.00'} dB',
                     style:  TextStyle(fontSize: 17,
                         fontWeight: FontWeight.bold,
                         color: Colors.deepPurple[200],
                     ),
                   ),
                 ],
               ),
             ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Average For 10 sec =  ',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[200]
                  ),
                ),
                Text(
                  '${_avarage.toStringAsFixed(2)} dB',
                  style:  TextStyle(fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[200],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: _isFlag? Icon( Icons.circle,color: Colors.red,size: 40,):Icon(
                Icons.circle,color: Colors.deepPurple[200],size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:SfCartesianChart(
                  series: <LineSeries<NoiseData, double >>[
                    LineSeries<NoiseData, double>(
                        dataSource: _noiseDataList,
                        xAxisName: 'Time',
                        yAxisName: 'dB',
                        name: 'dB values over time',
                        xValueMapper: (NoiseData value, _) => value.time,
                        yValueMapper: (NoiseData value, _) => value.noiseLevel,
                        animationDuration: 0),
                  ],
                )
              ),
            ),
          ],
        ),
      );
  }


}


