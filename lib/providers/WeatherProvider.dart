import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier{
  final WeatherService _weatherService =
      WeatherService(apiKey : dotenv.env['WEATHER_API_KEY'] ?? '');
  WeatherModel ? _weatherModel;
  bool _isLoading = true;

  WeatherModel? get weatherModel => _weatherModel;
  bool get isLoading => _isLoading;

  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try{
      String cityName = await _weatherService.getCurrentLocation();
      _weatherModel = await _weatherService.getWeather(cityName);
    }catch (e){
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}