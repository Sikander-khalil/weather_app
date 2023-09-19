import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Location _location = Location();
  bool _isLoading = true;
  double? _latitude;
  double? _longitude;
  String _apiKey = "87cbfdaf7f0597458d97e8b3daa898d8";
   Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      await Location().requestPermission();
      LocationData locationData = await _location.getLocation();
      setState(() {
        _latitude = locationData.latitude;
        _longitude = locationData.longitude;
        _isLoading = false;
        _fetchWeatherData(); // Fetch weather data after getting location
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _fetchWeatherData() async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?lat=$_latitude&lon=$_longitude&appid=$_apiKey&units=metric";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(response.body);

        });
      } else {
        print("Failed to load weather data");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _weatherData == null
          ? Center(
        child: Text('Weather data not available'),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Latitude: $_latitude"),
            Text("Longitude: $_longitude"),
            Text("Temperature: ${_weatherData!['main']['temp']}°C"),
            Text("Weather: ${_weatherData!['weather'][0]['main']}"),
            Text("City: ${_weatherData!['name']}"), // Display city name
          ],
        ),
      ),
    );
  }
}
