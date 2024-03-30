class Weather {
  final String cityName;
  final double temperature;
  final String weatherIcon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.weatherIcon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];

    return Weather(
        cityName: json['name'],
        temperature: main['temp'].toDouble(),
        weatherIcon: weather['icon']);
  }
}
