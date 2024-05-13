import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey = 'YOUR_API_KEY';
  final String baseUrl = 'https://api.openweathermap.org/data/3.0/onecall';

  Future<Weather> fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
