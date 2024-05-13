import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/geocoding_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final GeocodingService _geocodingService = GeocodingService();

  Weather? _weather;
  bool _isLoading = false;
  List<String> _citySuggestions = [];
  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherByLocation();
  }

  Future<void> _fetchWeatherByLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      final weather = await _weatherService.fetchWeather(
          position.latitude, position.longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByCity(String cityName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get latitude and longitude for the city using Geocoding API
      final response = await http.get(Uri.parse(
          'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=YOUR_API_KEY'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final latitude = data[0]['lat'];
          final longitude = data[0]['lon'];
          final weather =
              await _weatherService.fetchWeather(latitude, longitude);
          setState(() {
            _weather = weather;
          });
        } else {
          // Handle case when no data is returned
          setState(() {
            _weather = null;
          });
        }
      } else {
        throw Exception('Failed to load city coordinates');
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCitySuggestions(String query) async {
    try {
      final suggestions = await _geocodingService.fetchCitySuggestions(query);
      setState(() {
        _citySuggestions = suggestions;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _weather != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('City: ${_weather!.cityName}'),
                    Text('Temperature: ${_weather!.temperature}°C'),
                    Text('Description: ${_weather!.description}'),
                    Text('Wind Speed: ${_weather!.windSpeed} m/s'),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'Enter city name',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _fetchCitySuggestions(value);
                              } else {
                                setState(() {
                                  _citySuggestions = [];
                                });
                              }
                            },
                            onSubmitted: (value) {
                              _fetchWeatherByCity(value);
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _citySuggestions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_citySuggestions[index]),
                                onTap: () {
                                  _cityController.text =
                                      _citySuggestions[index];
                                  _fetchWeatherByCity(_citySuggestions[index]);
                                  setState(() {
                                    _citySuggestions = [];
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: Text('No weather data available')),
    );
  }
}
