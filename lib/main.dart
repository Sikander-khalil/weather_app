import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'home_binding.dart';
import 'homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,


     initialRoute: '/',
      getPages: [

        GetPage(name: '/', page: () => HomeScreen(),
        binding: HomeBinding(),

        )
      ],
    );
  }
}


