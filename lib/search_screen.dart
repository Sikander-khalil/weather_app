import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/weather_data.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  var api = 'https://api.openweathermap.org/data/2.5/weather';

  void fetchWeatherData(BuildContext context) async {
    var response = await http.get(
        Uri.parse('$api?q=${searchController.text}&appid=87cbfdaf7f0597458d97e8b3daa898d8'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String cityName = data['name'];
      double temperature = data['main']['temp'];



      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDataScreen(cityName, temperature),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                fetchWeatherData(context);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchWeatherData(context);
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
