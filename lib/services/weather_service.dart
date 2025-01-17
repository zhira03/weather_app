import 'dart:convert';
import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BaseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;
  final int maxCallsPerMin = 10;
  final Duration timeoutDuration = Duration(seconds: 5);

  int callCount = 0;
  Timer? resetTimer;

  WeatherService({
    required this.apiKey
  });

  Future<void>_checkRateLimit() async {
    if (callCount >= maxCallsPerMin){
      throw Exception("Rate limit exceeded. Please wait before making more requests.");
    }
    callCount++;
    resetTimer ??= Timer(Duration(minutes: 1), (){
      callCount = 0;
      resetTimer = null;
    });
  }

  Future<WeatherModel>getWeather(String cityName) async {
    await _checkRateLimit();
    try{
      final response = await http
          .get(Uri.parse("$BaseUrl?q=$cityName&appid=$apiKey&units=metric"))
          .timeout(timeoutDuration);

      if (response.statusCode ==200){
        return WeatherModel.fromJson(jsonDecode(response.body));
      }else {
        throw Exception("Failed to load Weather Data");
      }
    } on TimeoutException{
      throw Exception("Request timed out after ${timeoutDuration.inSeconds} seconds.");
    }
  }

  Future<String> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String? city = placemarks[0].locality;
      return city ?? "Harare"; // Default to London if city is null
    } catch (e) {
      print("Error fetching location: $e");
      return "Harare"; // Default city
    }
  }
}