import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  final String apiKey = '2992c0652da8302548c78a7ada23316b';
  final String baseUrl = 'http://api.openweathermap.org/geo/1.0/direct';

  Future<List<String>> fetchCitySuggestions(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl?q=$query&limit=5&appid=$apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item['name'].toString()).toList();
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }
}
