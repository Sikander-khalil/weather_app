import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ForCast extends StatefulWidget {
  const ForCast({super.key});

  @override
  State<ForCast> createState() => _ForCastState();
}

class _ForCastState extends State<ForCast> {

  List<WeatherData> weatherData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=lahore&appid=87cbfdaf7f0597458d97e8b3daa898d8"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> list = jsonData['list'];

      setState(() {
        weatherData.clear();
        for (final item in list) {
          weatherData.add(WeatherData.fromJson(item));
        }
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Forecast"),),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Text('Weather Forecast for Lahore (Next 5 Days):'),

            Expanded(child: Padding(


              padding: const EdgeInsets.all(8.0),
              child: WeatherChart(weatherData),
            ))


          ],
        ),
      ),
    );
  }
}

class WeatherData {
  final DateTime date;
  final double temperature;

  WeatherData({required this.date, required this.temperature});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'].toDouble(),
    );
  }
}




class WeatherChart extends StatelessWidget {
  final List<WeatherData> data;

  const WeatherChart(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: charts.TimeSeriesChart(
        _createData(),
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  List<charts.Series<WeatherData, DateTime>> _createData() {
    return [
      charts.Series<WeatherData, DateTime>(
        id: 'Weather',
        data: data,
        domainFn: (WeatherData weather, _) => weather.date,
        measureFn: (WeatherData weather, _) => weather.temperature,
      ),
    ];
  }
}