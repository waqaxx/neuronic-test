import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neuronic_test/models/weather.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();
  Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter city name',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _searchWeather(),
              ),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (String value) {
              _searchWeather();
            },
          ),
          SizedBox(
            height: 10,
          ),
          _buildWeatherDisplay()
        ],
      ),
    );
  }

  Widget _buildWeatherDisplay() {
    if (_weather == null) {
      return SizedBox.shrink();
    } else {
      return Column(
        children: [
          Text('City: ${_weather!.cityName}'),
          Text('Temperatur: ${_weather!.temperature}')
        ],
      );
    }
  }

  Future<void> _searchWeather() async {
    String cityName = _controller.text.trim();
    if (cityName.isNotEmpty) {
      final apiKey = '8c8be8b971ad6a60dfd426dd18a65dff';
      final apiUrl =
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

      try {
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            _weather = Weather.fromJson(jsonData);
          });
        } else {
          setState(() {
            _weather = null;
          });

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('City not found. Please try again.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'))
                    ],
                  ));
        }
      } catch (error) {
        print('Error fetching weather. $error');
      }
    }
  }
}
