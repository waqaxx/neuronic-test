import 'package:flutter/material.dart';
import 'package:neuronic_test/widgets/weather_display.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Column(
        children: [
          SearchBar(),
          Expanded(
            child: WeatherDisplay(),
          )
        ],
      ),
    );
  }
}
