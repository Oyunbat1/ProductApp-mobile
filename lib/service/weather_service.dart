import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "ecd7e86a656b6f148e13f42074b1895c";

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final currentUri =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
    try {
      final currentResponse = await http.get(Uri.parse(currentUri));

      if (currentResponse.statusCode == 200) {
        final currentJson = jsonDecode(currentResponse.body);
        print('--CurrentWeatherData-- $currentJson');
        currentJson['cityName'] = currentJson['name'] ?? 'Unknown';
        currentJson['temp'] = currentJson['main']['temp']?.round() ?? 0;
        currentJson['icon'] = currentJson['weather'][0]['icon'];
        return currentJson;
      }
    } catch (err) {
      throw Exception('Сүлжээний алдаа: $err');
    }
    return null;
  }

  Future<List<dynamic>> fetchForecast(String city) async {
    final forecastUri =
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric";
    try {
      final response = await http.get(Uri.parse(forecastUri));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('FORECASTDATA: $data');
        final list = data['list'] as List;
        return list;
      }
    } catch (err) {
      print('Error fetching forecast: $err');
    }
    return [];
  }
}
