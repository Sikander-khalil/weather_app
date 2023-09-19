

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weather_app/weather_data.dart';
import 'dart:convert';


import 'home_controller.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'mymodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Location _location = Location();
  bool _isLoading = true;
  double? _latitude;
  double? _longitude;
  List<WeatherData> weatherData = [];
  String _apiKey = "87cbfdaf7f0597458d97e8b3daa898d8";
  late Map<String, dynamic> _weatherData = {};
  TextEditingController searchController = TextEditingController();
  var api = 'https://api.openweathermap.org/data/2.5/weather';
  String cityName = '';
  double temperature = 0.0;






  @override
  void initState() {
    super.initState();
    _getLocation();
    getApiCall();
    getAnotherApiCall();
    getThirdApiCall();
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

  Future<void> _getLocation() async {
    try {
      await Location().requestPermission();
      LocationData locationData = await _location.getLocation();
      setState(() {
        _latitude = locationData.latitude;
        _longitude = locationData.longitude;
        _isLoading = false;
        _fetchWeatherData();

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

  Future<MyModel> getApiCall() async{

    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=Paris&appid=87cbfdaf7f0597458d97e8b3daa898d8"));





    if(response.statusCode == 200){


      final decoded = jsonDecode(response.body);



      return MyModel.fromJson(decoded);

    }else{

      throw Exception('Failed to load data. Status Code: ${response.statusCode}, Response Body: ${response.body}');


    }







  }
  Future<MyModel> getAnotherApiCall() async{

    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=London&appid=87cbfdaf7f0597458d97e8b3daa898d8"));





    if(response.statusCode == 200){


      final decoded = jsonDecode(response.body);



      return MyModel.fromJson(decoded);

    }else{

      throw Exception('Failed to load data. Status Code: ${response.statusCode}, Response Body: ${response.body}');


    }







  }
  Future<MyModel> getThirdApiCall() async{

    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=Tokyo&appid=87cbfdaf7f0597458d97e8b3daa898d8"));





    if(response.statusCode == 200){


      final decoded = jsonDecode(response.body);



      return MyModel.fromJson(decoded);

    }else{

      throw Exception('Failed to load data. Status Code: ${response.statusCode}, Response Body: ${response.body}');


    }







  }

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



      body: GetBuilder<HomeController>(


        builder: (controller) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(

                width: MediaQuery.of(context).size.width,

                height: 400,

                decoration: BoxDecoration(

              image: DecorationImage(

                image: NetworkImage(
                  'https://thumbs.dreamstime.com/b/blue-sky-clouds-background-beautiful-white-fluffy-light-clearing-day-good-weather-morning-copy-space-152373441.jpg',



                ),

                fit: BoxFit.cover,



              ),
              borderRadius: BorderRadius.only(

                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              )
                ),
                child: Stack(

                  children: [

                    Container(

                      child: AppBar(

                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(

                          icon: Icon(Icons.menu,
                          color: Colors.white,),
                          onPressed: (){},
                        ),

                      ),
                    ),
                    Container(

                      padding: EdgeInsets.only(top: 100,left: 20,right: 20),
                      child: TextField(

                        controller: searchController,

                        onSubmitted: (value){
                          fetchWeatherData(context);

                        },
                        style: TextStyle(

                          color: Colors.white
                        ),
                        textInputAction: TextInputAction.search,

                        decoration: InputDecoration(
                          suffix: Icon(

                            Icons.search,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Search'.toUpperCase(),
                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),

                      ),
                    ),

                    Align(

                      alignment: Alignment(0.0, 0.5),
                      child: SizedBox(

                        height: 10,
                        width: 10,
                        child: OverflowBox(

                          minWidth: 0.0,
                          maxWidth: MediaQuery.of(context).size.width,
                          minHeight: 0.0,
                          maxHeight: (MediaQuery.of(context).size.height / 3.5),

                          child: Stack(

                            children: [

                              Container(

                                padding: EdgeInsets.symmetric(horizontal: 15),
                                width: double.infinity,
                                height: double.infinity,
                                child: Card(


                                  color: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(

                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Column(

                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Container(

                                        padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                                        child: Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text("City: ${_weatherData['name'] ?? 'N/A'}", style: TextStyle(fontSize: 17)),
                                            ),


                                            Center(

                                              child: Text(

                                                DateFormat().add_MMMMEEEEd().format(DateTime.now()),

                                                style: Theme.of(context).textTheme.caption!.copyWith(

                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      Row(children: [

                                        Container(


                                          padding: EdgeInsets.only(left: 30),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              SizedBox(height: 20,),

                                              Text("OverCast Clouds",style: TextStyle(fontSize: 15),),
                                              SizedBox(height: 20,),
                                              Text('${_weatherData['main']?['temp']}°C', style: TextStyle(color: Colors.black, fontSize: 15)),

                                              SizedBox(height: 20,),
                                              Text("min: ${_weatherData['main']?['temp_min'] ?? 'N/A'} / max: ${_weatherData?['main']?['temp_max'] ?? 'N/A'}", style: TextStyle(color: Colors.black, fontSize: 15)),



                                            ],
                                          ),
                                        ),
                                        Container(

                                          padding: EdgeInsets.only(right: 20),
                                          child: Column(

                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [

                                              Container(
                                                margin: EdgeInsets.only(left: 10),

                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(


                                                  image: DecorationImage(

                                                    image: NetworkImage(
                                                      'https://cdn2.iconfinder.com/data/icons/weather-flat-14/64/weather02-512.png'

                                                    ),
                                                    fit:  BoxFit.cover
                                                  )
                                                ),
                                              ),
                                              Container(







                                                child: Text("Wind: ${_weatherData['wind']?['speed'] ?? 'N/A'}",style: TextStyle(color: Colors.black,fontSize: 19),),
                                              )
                                            ],
                                          ),
                                        )
                                      ],)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),

                        ),
                      ),
                    )
                  ],
                ),

              ),
              Stack(


                children: [


                  Padding(padding: EdgeInsets.symmetric(horizontal: 15),

                    child: Container(

                      padding: EdgeInsets.only(top: 20),
                      child: Align(

                        alignment: Alignment.topLeft,
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(

                              margin: EdgeInsets.only(bottom: 27),


                              child: Text('Other Cities:-',style: TextStyle(color: Colors.black,fontSize: 19),),

                            ),


                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Card(
                                    shape: BeveledRectangleBorder(

                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                      ),
                                      child: FutureBuilder(
                                        future: getApiCall(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text("Error: ${snapshot.error}"),
                                            );
                                          } else if (snapshot.data == null) {
                                            return Center(
                                              child: Text("No data available"),
                                            );
                                          } else {
                                            final weather = snapshot.data;

                                            return Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        weather!.name.toString(),
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Center(
                                                      child: Text('${weather.wind!.speed.toString()} °C',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 30,),
                                  Card(
                                    shape: BeveledRectangleBorder(

                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                      ),
                                      child: FutureBuilder(
                                        future: getAnotherApiCall(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text("Error: ${snapshot.error}"),
                                            );
                                          } else if (snapshot.data == null) {
                                            return Center(
                                              child: Text("No data available"),
                                            );
                                          } else {
                                            final weather = snapshot.data;

                                            return Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        weather!.name.toString(),
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Center(
                                                      child: Text('${weather.wind!.speed.toString()} °C',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 30,),
                                  Card(
                                    shape: BeveledRectangleBorder(

                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                      ),
                                      child: FutureBuilder(
                                        future: getThirdApiCall(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text("Error: ${snapshot.error}"),
                                            );
                                          } else if (snapshot.data == null) {
                                            return Center(
                                              child: Text("No data available"),
                                            );
                                          } else {
                                            final weather = snapshot.data;

                                            return Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        weather!.name.toString(),
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Center(
                                                      child: Text('${weather.wind!.speed.toString()} °C',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),


                                                  ],
                                                ),

                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),










                          ],
                        ),
                      ),
                    ),

                  ),

                ],
              ),
              SizedBox(height: 10,),


              Text("Next 5 Days Forcast",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),

              Container(

                height: 900,



                child: WeatherChart(weatherData),
              ),
            ],
          ),
        ),



      )


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