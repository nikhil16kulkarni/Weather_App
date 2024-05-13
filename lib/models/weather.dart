class Weather {
  final double temperature;
  final double windSpeed;
  final String description;
  final String cityName;

  Weather(
      {required this.temperature,
      required this.windSpeed,
      required this.description,
      required this.cityName});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        temperature: json['current']['temp'],
        windSpeed: json['current']['wind_speed'],
        description: json['current']['weather'][0]['description'],
        cityName: json['timezone']);
  }
}
